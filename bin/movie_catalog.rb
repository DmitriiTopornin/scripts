require_relative '../lib/movie'
require_relative '../lib/movies_list'
require_relative '../lib/parse'
require_relative '../lib/print_films'
require_relative '../lib/rating'
require_relative '../lib/tmdb_api'
# require_relative 'movie_catalog/methods_module'
require 'optparse'

movies = MyMoviesList.from_json

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"

  opts.on("-r", "--rate MOVIE_TITLE RATING", "Rate film") do |movie|
    current_movie = movies.rate(movie, ARGV[0]) 
    puts "movie title: #{movie}, my_rating: #{ARGV[0]}" 
  end

  
end.parse!

