ARGV.each do |movie|
	good_movie = ["Matrix", "Inception"]
	bad_movie = ["Titanic", "Tangled"]
	case movie.capitalize
		when *good_movie
			puts "#{movie.capitalize} is a good movie"
		when *bad_movie
			puts "#{movie.capitalize} is a bad movie"
		else 
			puts "Haven't seen #{movie.capitalize} yet"
	end
end