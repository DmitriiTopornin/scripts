require_relative 'rating'
class Movie
  attr_accessor :url, :title, :year,
                :country, :date, :genre, 
                :duration, :rating, :director,
                :actors

  def initialize(movie, movie_list)
    @url = movie[:url]
    @title = movie[:title]
    @year = movie[:year]
    @country = movie[:country]
    if movie[:date].include? '-'
      @date = Date.strptime(movie[:date],'%Y-%m')
    else
      @date = Date.strptime(movie[:date],'%Y')
    end
    @genre = movie[:genre]
    @duration = movie[:duration].split(' ').first.to_i
    @rating = movie[:rating]
    @director = movie[:director]
    @actors = movie[:actors]
    @owner = movie_list
  end

  include Rating::Item

  def self.category(movie, movie_list)
    filters.detect{|movie_class, block| block.call(movie[:year].to_i)}.first.new(movie, movie_list)
  end

  def self.filters
    @filters ||= {}
  end 

  def self.filter(&block)
    Movie.filters[self] = block
  end

  def self.movie_params
    @movie_params ||= {} 
  end

  def self.print_format(print_format)
    @print_format = print_format
  end

  def self.get_print_format
    @print_format
  end

  def self.weight(weight)
    @weight = weight
  end

  def self.get_weight
    @weight
  end

  def description
    self.class.get_print_format % self.to_h
  end

  protected

  def to_h
    # puts @owner.class
    {
     year: @year,
     director: @director,
     director_movies_count: @owner.director_movies(@director).count,
     actors: @actors
    }
  end

  def method_missing(method_sym, *arguments, &block)
    raise ArgumentError, 'Wrong number of arguments' unless arguments.count == 0
    genre_var = method_sym.to_s.capitalize
    if genre_var.include?('?') && @owner.genre_list.include?(genre_var.chomp('?'))
      @genre.include? genre_var
    else
      super
    end
  end

end

require_relative 'movie/ancient_movie'
require_relative 'movie/classic_movie'
require_relative 'movie/modern_movie'
require_relative 'movie/new_movie'