class Movie
  attr_accessor :url, :title, :year,
                :country, :date, :genre, 
                :duration, :rating, :director,
                :actors, :watch, :my_rating
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
    @watch = FALSE
    @my_rating = nil
    @owner = movie_list
  end

  def watched?
    watch
  end

  def self.category(movie, movie_list)
    case movie[:year].to_i
      when 1900..1945
        AncientMovie
      when 1946..1968
        ClassicMovie
      when 1969..2000
        ModernMovie
      when 2001..Date.today.year
        NewMovie
    end.new(movie, movie_list)
  end
end


class AncientMovie < Movie
  PREFERENCES = 1
  def description
    @about = "старый фильм (#{@year})"
  end
end

class ClassicMovie < Movie
  PREFERENCES = 5
  def description
    @about = "классический фильм, режиссер: #{@director} - #{@owner.director_movies('director').count}"
  end
end

class ModernMovie < Movie
  PREFERENCES = 1
  def description
    @about = "современный фильм, играют: #{@actors}"
  end
end

class NewMovie < Movie
  PREFERENCES = 2
  def description
    @about = "Новинка!"
  end
end