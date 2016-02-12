require 'json'
require 'progress_bar'

class ImdbParser

  def self.parse_top(file_name)
    @movies = []
    get_list
    create_json(file_name)
  end

  private

  def self.create_json(file_name)
    File.open("#{file_name}.json", "w+") do |file|
      file.write(@movies.to_json)
    end
  end

  def self.parse_movie(movie_url, current_movie)
    mov = {}
    mov[:url] = movie_url
    current_movie = Nokogiri::HTML(open(movie_url))
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


  def self.get_movie(movie_url)
    doc = Nokogiri::HTML(open(movie_url))
    parse_movie(movie_url, doc)
  end

  def self.get_list
    url="http://www.imdb.com/chart/top"
    doc = Nokogiri::HTML(open(url))
    bar = ProgressBar.new(doc.css("table tbody tr td.titleColumn a").map{|movie| url[0..18]+movie["href"]}.count)
    doc.css("table tbody tr td.titleColumn a").map{|movie| url[0..18]+movie["href"]}.each do |movie_url|
      @movies << get_movie(movie_url)
      bar.increment!
    end
  end
end