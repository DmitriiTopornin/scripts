require_relative 'lib/movies_list'
require_relative 'lib/print_films'
require_relative 'lib/parse'




ImdbParser.parse_top("temp")
# movies = MyMoviesList.from_json

# print_films movies.all
# print_films movies.all.reject(&:drama?)
# print_films movies.by_genre('Crime')
# print_films movies.exclude_genre('Crime')
# print_films movies.sort_by('title')
# print_films movies.longest(10)
# print_films movies.genre_date('Crime')
# print_films movies.not_from('USA')
# print_stats movies.actors_movies_count
# print_stats movies.directors_movies_count
# print_stats movies.count_by_month
# movies.rate('Крёстный отец (1972)', 3.2)
# print_films movies.random_not_watched
# print_films movies.random_watched
# puts movies.all
# movies.print {|movie| "#{movie.title}"}
# print_films movies.sorted_by {|movie| [movie.genre, movie.year]}
# movies.add_sort_algo(:test) {|movie| [movie.genre, movie.year]}
# print_films movies.sorted_by(:test)
# movies.add_filter(:genres){|movie, *genres| genres.include?(movie.genre)}
# movies.add_filter(:years){|movie, from, to| (from..to).include?(movie.year.to_i)}

# print_films movies.filter(
#     genres: ['Comedy'],
#     years: [1890, 2010]
#   )