require 'json'
require 'eventmachine'
require 'em-http-request'

class ImdbParser

  def self.parse_top(file_name)
    url="http://www.imdb.com/chart/top"
    starttime = Time.now
    @movies = []
    @fail_urls = []
    assync_request(url)
    @fail_urls.each {|movie_url| @movies << parse_movie(movie_url, Nokogiri::HTML(open(movie_url)))}
    puts "----"
    puts Time.now - starttime
    puts "----"
    create_json(file_name)
  end

  private

  def self.create_json(file_name)
    File.open("#{file_name}.json", "w+") do |file|
      file.write(@movies.to_json)
    end
  end

  def self.parse_movie(movie, current_movie)
    mov = {}
    mov[:url] = movie
    mov[:rating] = current_movie.at("div.ratingValue span[itemprop='ratingValue']").content
    mov[:title] = current_movie.at("div.title_wrapper h1[itemprop='name']").content.strip
    mov[:year] = current_movie.at("div.title_wrapper h1[itemprop='name'] span").content.tr("()","")
    mov[:duration] = current_movie.at("div.subtext time").attributes["datetime"].content.gsub(/[^0-9]/, "")
    mov[:genre] = current_movie.css("div.subtext a span.itemprop").map(&:content)
    mov[:country] = current_movie.at("div.subtext a[title='See more release dates']").content.split.last.tr("()","")
    if current_movie.css("div.subtext a")[2].nil? || current_movie.css("div.subtext a")[2].children[1].nil?
      mov[:date] = current_movie.at("div.subtext a meta")['content']
    else
      mov[:date] = current_movie.css("div.subtext a")[2].children[1].attributes["content"].value
    end
    mov[:director] = current_movie.at("div.credit_summary_item span[itemprop='director']").content.strip
    mov[:actors] = current_movie.css("div.credit_summary_item span[itemprop='actors']").map{|actors| actors.content.strip.tr(",","")}.join(", ")
    mov
  end

  def self.assync_request(url)
    doc = Nokogiri::HTML(open(url))
    counter = 0
    fail_counter = 0
    EventMachine.run do
    doc.css("table tbody tr td.titleColumn a").map{|movie| url[0..18]+movie["href"]}.each_with_index do |movie, index|
      http = EventMachine::HttpRequest.new(movie).get timeout: 15
      http.errback do
        puts "FAIL! #{index}"; fail_counter += 1; counter += 1
        @fail_urls << movie
        EventMachine.stop if counter == 250
      end
      http.callback do 
        puts "OK! #{index}" 
        counter += 1 
        puts counter
        @movies << parse_movie(movie, Nokogiri::HTML(http.response))
        EventMachine.stop if counter == 250
      end
    end
    end
  end
end