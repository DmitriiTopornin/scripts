class Movie
  attr_accessor :url, :title, :year,
                :country, :date, :genre, 
                :duration, :rating, :director,
                :actors, :watch, :my_rating,
                :about, :preferences
  def initialize(movie)
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
    @watch = FALSE
    @my_rating = nil
    @preferences = 1
    case self
      when AncientMovie
        @about = "старый фильм (#{@year})"
      when ClassicMovie
        @about = "классический фильм, режиссер: #{@director}"
      when ModernMovie
        @about = "современный фильм, играют: #{@actors}"
      when NewMovie
        @about = "Новинка!" 
    end
  end
end


class AncientMovie < Movie
end

class ClassicMovie < Movie
end

class ModernMovie < Movie
end

class NewMovie < Movie
end