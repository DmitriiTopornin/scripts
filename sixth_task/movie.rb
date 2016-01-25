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
    description
  end

  def self.category(movie)
    case movie[:year].to_i
      when 1900..1945
        AncientMovie.new(movie)
      when 1946..1968
        ClassicMovie.new(movie)
      when 1969..2000
        ModernMovie.new(movie)
      when 2001..Date.today.year
        NewMovie.new(movie)
      end    
  end
end


class AncientMovie < Movie
  private

  def description
    @about = "старый фильм (#{@year})"
    @preferences = 1
  end
end

class ClassicMovie < Movie
  private

  def description
    @about = "классический фильм, режиссер: #{@director}"
    @preferences = 2
  end
end

class ModernMovie < Movie
  private

  def description
    @about = "современный фильм, играют: #{@actors}"
    @preferences = 3
  end
end

class NewMovie < Movie
  private

  def description
    @about = "Новинка!"
    @preferences = 2
  end
end