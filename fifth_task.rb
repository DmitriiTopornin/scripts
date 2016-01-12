require_relative 'movies_list'


movies = MoviesList.new
puts movies.include_genre('Crime')
puts movies.exclude_genre('Crime')
puts movies.sort_by('title')
puts movies.top_longest_films(10)
puts movies.genre_date('Crime')
puts movies.directors_list
puts movies.not_from('USA')
puts movies.directors_movies_count
puts movies.actors_movies_count
puts movies.count_by_month