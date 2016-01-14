require_relative 'movies_list'
require_relative 'print_films'


movies = MoviesList.new
# puts movies.by_genre('Crime')
# puts movies.exclude_genre('Crime')
# puts movies.sort_by('title')
# puts movies.longest(10)
# puts movies.genre_date('Crime')
# puts movies.directors
# puts movies.not_from('USA')
# puts movies.directors_movies_count
# puts movies.actors_movies_count
# puts movies.count_by_month

print_films movies.by_genre('Crime')
print_films movies.by_genre('Crime')
print_films movies.exclude_genre('Crime')
print_films movies.sort_by('title')
print_films movies.longest(10)
print_films movies.genre_date('Crime')
print_films movies.not_from('USA')
print_films movies.directors
print_films movies.actors_movies_count
print_films movies.directors_movies_count
print_films movies.count_by_month