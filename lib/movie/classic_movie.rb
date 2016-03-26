require_relative '../movie'

class ClassicMovie < Movie
  filter { |year| (1946..1968).cover?(year) }
  print_format "классический фильм, режиссер  %{director}, кол-во фильмов: %{director_movies_count}"
  weight 0.6
end