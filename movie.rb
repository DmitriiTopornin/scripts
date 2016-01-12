class Movie
	attr_accessor :url, :title, :year, :country, :date, :genre, :duration, :rating, :director, :actors

	def initialize(movies)
		@url = movies['url']
		@title = movies['title']
		@year = movies['year']
		@country = movies['country']
		@date = movies['date']
		@genre = movies['genre']
		@duration = movies['duration']
		@rating = movies['rating']
		@director = movies['director']
		@actors = movies['actors']
	end
end