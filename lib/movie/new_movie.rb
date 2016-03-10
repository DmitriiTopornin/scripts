require_relative '../movie'

class NewMovie < Movie
  filter { |year| (2001..Date.today.year).cover?(year) }
  print_format "Новинка!"
  weight 0.6
end