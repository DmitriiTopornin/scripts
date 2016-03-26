require_relative '../movie'

class AncientMovie < Movie
  filter { |year| (1900..1945).cover?(year) }
  print_format "старый фильм %{year}"
  weight 0.6
end