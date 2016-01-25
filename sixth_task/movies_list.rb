require_relative 'movie'
require 'ostruct'
require 'csv'
require 'date'

COLUMNS = %i[url title year country date genre duration rating director actors]

class MoviesList
  def initialize(file_name = '../../movies.txt')
    parse_csv(file_name)
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
      select{|movie| movie.genre.split(',').include? ingenre}.
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

private

  def parse_csv(file_name = '../../movies.txt')
    raise "File \"#{file_name}\" not found" unless File.exist? file_name
    @movies = CSV.read(file_name, col_sep: "|", headers: COLUMNS).
    map{|movie| case movie.to_hash[:year].to_i 
                  when 1900..1945 then AncientMovie.new(movie.to_hash)
                  when 1946..1968 then ClassicMovie.new(movie.to_hash)
                  when 1969..2000 then ModernMovie.new(movie.to_hash)
                  when 2001..Date.today.year then NewMovie.new(movie.to_hash) end }
  end

end


class MyMoviesList < MoviesList
  def initialize(file_name = '../../movies.txt')
    parse_csv(file_name)
  end

  def rate(movie_title, my_rating)
    movie = @movies[ @movies.index{ |movie| movie.title == movie_title } ]
    movie.watch = TRUE
    movie.my_rating = my_rating
    movie
  end

  def random_not_watched(count = 5)
    @movies.select {|movie| movie.watch == FALSE}
      .sort_by {|movie| rand*movie.rating.to_f*movie.preferences.to_f }.last(5)
  end

  def random_watched
    @movies.select {|movie| movie.watch == TRUE}
      .sort_by {|movie| rand*movie.rating.to_f*movie.preferences.to_f }.last(5)
  end

  def preferences(categories_array)
    @movies.each {|movie| if categories_array.include? movie.class.name then movie.preferences = 2 end}
  end
end