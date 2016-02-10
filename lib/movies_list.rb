require_relative 'movie'
require_relative 'rating'
require 'ostruct'
require 'csv'
require 'date'
require 'open-uri'
require 'nokogiri'

COLUMNS = %i[url title year country date genre duration rating director actors]

class MoviesList
  def initialize(key = :csv, file_name = '../movies.txt')
    $call_sort_block = nil
    if key == :csv
      parse_csv(file_name)
    elsif key == :json
      parse_json(file_name)
    end
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

  def parse_csv(file_name)
    raise "File \"#{file_name}\" not found" unless File.exist? file_name
    @movies = CSV.read(file_name, col_sep: "|", headers: COLUMNS).
      map{|movie| Movie.category(movie.to_hash, self) }
  end

  def parse_json(file_name)
    raise "File \"#{file_name}\" not found" unless File.exist? file_name
    @movies = JSON.parse(File.open(file_name, "r").read).
      map {|movie_hash| Movie.category(movie_hash.inject({}) {|memory,(key,value)| memory[key.to_sym] = value; memory}, self)}
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