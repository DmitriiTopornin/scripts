require 'json'

class Parse
  attr_accessor :movies

  def initialize(url="http://www.imdb.com/chart/top")
    site(url)
  end

  def site(url)
    starttime = Time.now
    doc = Nokogiri::HTML(open(url))
    @movies = []
    doc.css("table tbody tr td.titleColumn a").map{|movie| url[0..18]+movie["href"]}.each_with_index do |movie, index|
      # break if index == 2
      mov = {}
      mov[:url] = movie
      firstmov = Nokogiri::HTML(open(movie))
      mov[:rating] = firstmov.css("div.ratingValue span[itemprop='ratingValue']").first.content
      mov[:title] = firstmov.css("div.title_wrapper h1[itemprop='name']").first.content.strip
      mov[:year] = firstmov.css("div.title_wrapper h1[itemprop='name'] span").first.content.tr("()","")
      mov[:duration] = firstmov.css("div.subtext time").
        first.content.to_s.strip.split.each_with_index.
        inject(0) {|sum,(value,index)|  index == 0 ? (sum+=value.tr("h min","").to_i*60) : (sum+=value.tr("h min","").to_i)}.to_s + " min"
      mov[:genre] = firstmov.css("a span.itemprop")[0].content + "," + firstmov.css("a span.itemprop")[1].content
      mov[:country] = firstmov.css("div.subtext a[title='See more release dates']").first.content.split.last.tr("()","")
      if firstmov.css("div.subtext a")[2].nil? || firstmov.css("div.subtext a")[2].children[1].nil?
        mov[:date] = firstmov.css("div.subtext a meta").first['content']
      else
        mov[:date] = firstmov.css("div.subtext a")[2].children[1].attributes["content"].value
      end
      mov[:director] = firstmov.css("div.credit_summary_item span[itemprop='director']").first.content.strip
      mov[:actors] = firstmov.css("div.credit_summary_item span[itemprop='actors']").map{|actors| actors.content.strip.tr(",","")}.join(", ")
      @movies << mov
    end
    puts @movies
    puts "----"
    puts Time.now - starttime
    puts "----"
  end

  def create_json(file_name)
    File.open("#{file_name}.json", "w+") do |file|
      file.write(@movies.to_json)
    end
  end
end