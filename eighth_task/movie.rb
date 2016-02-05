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
    filters.map do |movie_class, block|
      movie_class.new(movie, movie_list) if block.call(movie[:year].to_i)   
    end.compact!.first
  end

  def self.filters
    @filters ||= {}
  end 

  def self.filter(&block)
    Movie.filters[self] = block
  end
end


class AncientMovie < Movie
  filter { |year| (1900..1945).cover?(year) }
  PREFERENCES = 1
  def description
    @about = "старый фильм (#{@year})"
  end
end

class ClassicMovie < Movie
  filter { |year| (1946..1968).cover?(year) }
  PREFERENCES = 5
  def description
    @about = "классический фильм, режиссер: #{@director} - #{@owner.director_movies(@director).count}"
  end
end

class ModernMovie < Movie
  filter { |year| (1968..2000).cover?(year) }
  PREFERENCES = 1
  def description
    @about = "современный фильм, играют: #{@actors}"
  end
end

class NewMovie < Movie
  filter { |year| (2001..Date.today.year).cover?(year) }
  PREFERENCES = 2
  def description
    @about = "Новинка!"
  end
end