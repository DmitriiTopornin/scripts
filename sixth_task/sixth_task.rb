require_relative 'movies_list'
require_relative 'print_films'


movies = MyMoviesList.new



# print_films movies.by_genre('Crime')
# print_films movies.by_genre('Crime')
# print_films movies.exclude_genre('Crime')
# print_films movies.sort_by('title')
# print_films movies.longest(10)
# print_films movies.genre_date('Crime')
# print_films movies.not_from('USA')
# puts movies.directors
# print_stats movies.actors_movies_count
# print_stats movies.directors_movies_count
# print_stats movies.count_by_month
# puts movies.all.map{|m| m.title}
movies.rate('Stand by Me', 3.2)
# print_films movies.random_not_watched
print_films movies.random_watched
# puts movies.all
# movies.all.each {|mv| puts mv.class::PREFERENCES}