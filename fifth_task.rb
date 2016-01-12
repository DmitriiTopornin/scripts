require_relative 'movies_list'


movies = MoviesList.new
puts movies.include_genre('Crime')
puts movies.exclude_genre('Crime')
puts movies.sort_by('title')
