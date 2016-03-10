require_relative '../movie'

class ModernMovie < Movie
  filter { |year| (1968..2000).cover?(year) }
  print_format "современный фильм, играют: %{actors}"
  weight 0.6
end