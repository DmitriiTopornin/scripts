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
# movies.rate('Stand by Me', 3.2)
# print_films movies.random_not_watched
# print_films movies.random_watched
# puts movies.all
# movies.all.each {|mv| puts mv.class::PREFERENCES}
# movies.print {|movie| "#{movie.title}"}
# print_films movies.sorted_by {|movie| [movie.genre, movie.year]}
movies.add_sort_algo(:test) {|movie| [movie.genre, movie.year]}
print_films movies.sorted_by(:tesst)
# movies.add_filter(:genres){|movie, *genres| genres.include?(movie.genre)}
# movies.add_filter(:years){|movie, from, to| (from..to).include?(movie.year.to_i)}

# print_films movies.filter(
#     genres: ['Comedy'],
#     years: [1890, 2010]
#   )