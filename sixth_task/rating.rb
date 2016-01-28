module Rating
	def rate(movie_title, my_rating)
    movie = @movies.detect{|movie| movie.title == movie_title}
    movie.watch = true
    movie.my_rating = my_rating
    movie
  end
end