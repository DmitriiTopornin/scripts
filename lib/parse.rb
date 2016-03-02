require 'json'
require 'progress_bar'

class ImdbParser

  @movies = []
  TOP_URL = "http://www.imdb.com/chart/top"

  def self.parse_top(file_name)
    get_list
    create_json(file_name)
  end

  private

  def self.create_json(file_name)
    File.open("#{file_name}.json", "w+") do |file|
      file.write(@movies.to_json)
    end
  end

  def self.get_movie(movie_url)
    doc = Nokogiri::HTML(open(movie_url))
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

  def self.get_list
    doc = Nokogiri::HTML(open(TOP_URL))
    movies_url_list = doc.css("table tbody tr td.titleColumn a").map{|movie| TOP_URL[0..18]+movie["href"]}
    bar = ProgressBar.new(movies_url_list.count)
    movies_url_list.each do |movie_url|
      @movies << get_movie(movie_url)
      bar.increment!
    end
  end
end