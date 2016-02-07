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
    @date = Date.strptime(movie[:date],'%Y-%m') if movie[:date].include? '-'
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
    self.class.get_print_format % {year: @year, director: @director, director_movies_count: @owner.director_movies(@director).count, actors: @actors}
  end

end


class AncientMovie < Movie
  filter { |year| (1900..1945).cover?(year) }
  print_format "старый фильм %{year}"
  weight 0.6
end

class ClassicMovie < Movie
  filter { |year| (1946..1968).cover?(year) }
  print_format "классический фильм, режиссер  %{director}, кол-во фильмов: %{director_movies_count}"
  weight 0.6
end

class ModernMovie < Movie
  filter { |year| (1968..2000).cover?(year) }
  print_format "современный фильм, играют: %{actors}"
  weight 0.6
end

class NewMovie < Movie
  filter { |year| (2001..Date.today.year).cover?(year) }
  print_format "Новинка!"
  weight 0.6
end