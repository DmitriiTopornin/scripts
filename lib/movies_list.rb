require_relative 'movie'
require_relative 'rating'
require 'ostruct'
require 'csv'
require 'date'
require 'open-uri'
require 'nokogiri'

COLUMNS = %i[url title year country date genre duration rating director actors]

class MoviesList
  def initialize
    $call_sort_block = nil
    # parse_csv
    parse_site
  end

  def all
    @movies.map{|movie| movie}
  end

  def by_genre(ingenre)
    @movies.select{|movie| movie.genre.include?(ingenre)}
  end

  def exclude_genre(exgenre)		
    @movies.reject{|movie| movie.genre.include?(exgenre)}
  end

  def sort_by(field)
    if @movies.first.respond_to? field
        @movies.sort_by{|movie| movie.send(field)}
    else
      raise "'#{field}' doesn't exist"
    end
  end

  def longest(count = 5)
    @movies.
      sort_by(&:duration).reverse.first(count)
  end

  def genre_date(ingenre = 'Comedy')
    @movies.
      select{|movie| movie.genre.include? ingenre}.
      sort_by(&:date)
  end

  def directors
    @movies.map(&:director).uniq.sort_by{|director| director.split.last}
  end

  def not_from(country = 'USA')
    @movies.reject{|movie| movie.country == country}.
      sort_by(&:country)
  end

  def directors_movies_count
    @movies.group_by(&:director).map{ |director, movies| {director => movies.count}}.
      reduce Hash.new, :merge
  end

  def actors_movies_count 
    @movies.
      map { |movie| movie.actors.split(',') }.
      flatten.reduce(Hash.new(0)) { |actors_hash, x| actors_hash[x] += 1; actors_hash }
  end

  def count_by_month
    @movies.reject{|movie| movie.date.nil? }.map(&:date).group_by(&:mon).
      sort.map { |month, movies| { Date::MONTHNAMES[month] => movies.count } }.
      reduce(:merge)
  end

  def director_movies(director)
    @movies.select{|movie| movie.director == director }
  end

  def print
    if block_given?  
      @movies.each {|movie| puts yield(movie)} 
    else 
      all 
    end
  end

  def sorted_by(name = nil,&block)
    sort_block = if block 
      block
    elsif name.is_a?(Symbol) && @sort_algo_hash.has_key?(name)
      @sort_algo_hash[name]
    else
      raise "Unknown name: #{name.inspect}"
    end
    @movies.sort_by(&sort_block)
  end

  def add_sort_algo(name, &block)
    @sort_algo_hash ||= {}
    @sort_algo_hash[name] = block
  end

  def add_filter(name, &block)
    @filter ||= {}
    @filter[name] = block
  end

  def filter(filters)
    filters.reduce(@movies) {|movies, (filter_name, val)| movies.select{|movie| @filter[filter_name].call(movie, *val)}}
  end

protected

  def parse_csv(file_name = '../movies.txt')
    raise "File \"#{file_name}\" not found" unless File.exist? file_name
    @movies = CSV.read(file_name, col_sep: "|", headers: COLUMNS).
      map{|movie| Movie.category(movie.to_hash, self) }
    # puts @movies
  end

  def parse_site(url="http://www.imdb.com/chart/top")
    doc = Nokogiri::HTML(open(url))
    # puts doc.css("table tbody tr td.titleColumn a").
    #   map do |movie| 
    #     Nokogiri::HTML(open(url[0..18]+movie["href"])).css("div.ratingValue span")}
    #   end
    # @movies = Hash.new
    mov = Hash.new
    mov [:url] = doc.css("table tbody tr td.titleColumn a").map{|movie| url[0..18]+movie["href"]}
    firstmov = Nokogiri::HTML(open(mov[:url].first))
    # film = open(url.first)
    puts mov[:rating] = firstmov.css("div.ratingValue span").first.content.to_s
    puts mov[:title] = firstmov.css("div.title_wrapper h1").first.content.to_s
    puts mov[:year] = mov[:title].split[2][10..13]
    #как это переделать чтобы работало адекватно - не знаю, сейчас просто заглушка которая возвращает строк
    puts mov[:duration] = firstmov.css("div.subtext time").first.content.to_s.strip.split.map {|s| s.tr('h min', '')}.reduce(&:+)
    puts mov[:genre] = firstmov.css("a span.itemprop")[0].content + "," + firstmov.css("a span.itemprop")[1].content
    puts mov[:country] = firstmov.css("div.subtext a")[2].content.split.last.tr("()","")
    puts mov[:date] = Date.parse(firstmov.css("div.subtext a")[2].content.split.reverse.drop(1).reverse.join)
    puts mov[:director] = firstmov.css("div.credit_summary_item a span.itemprop")[0].content
    puts mov[:actors] = firstmov.css("div.credit_summary_item a span.itemprop")[3].content
  end
  
end


class MyMoviesList < MoviesList

  include Rating::List

  def random_not_watched
    @movies.reject(&:watched?)
      .sort_by {|movie| rand*movie.rating.to_f*movie.class.get_weight.to_f }.last(5)
  end

  def random_watched
    @movies.select(&:watched?)
      .sort_by {|movie| rand*movie.rating.to_f*movie.class.get_weight.to_f }.last(5)
  end

  def genre_list
    @genre ||= @movies.map {|movie| movie.genre }.flatten.uniq!
  end
end