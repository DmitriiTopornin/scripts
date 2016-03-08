require "themoviedb-api"
require 'progress_bar'

class TmdbApi	
  
  API_PAGES_COUNTER = 13

	def initialize
		unless Tmdb::Api.key("c489890902172b55bb380ecf8472e46a")
			raise "invalid api key"
		end
	end

	def fetcher
		bar = ProgressBar.new(API_PAGES_COUNTER)
    movies = []
    (1..API_PAGES_COUNTER).each do |page_counter|
      api_movies = Tmdb::Movie.top_rated(page: page_counter)
      api_movies.results.map do |movie|
      	movie_hash = {}
      	movie_hash[:title] = movie.title
      	movie_hash[:date] = movie.release_date
      	movie_hash[:rating] = movie.vote_average
      	movie_detail = Tmdb::Movie.detail(movie.id)
      	movie_hash[:url] = 'http://www.imdb.com/title/' + movie_detail.imdb_id
      	movie_hash[:year] = movie_hash[:date].split('-').first
      	movie_hash[:country] = movie_detail.production_countries.map(&:iso_3166_1).join(", ")
      	movie_hash[:genre] = movie_detail.genres.map(&:name)
      	movie_hash[:duration] = movie_detail.runtime
      	movie_hash[:director] = Tmdb::Movie.director(movie.id).map(&:name).join(", ")
      	movie_hash[:actors] = Tmdb::Movie.cast(movie.id).map(&:name).join(", ")
      	movies << movie_hash
      end
		  bar.increment!
		end
		movies.slice!(movies.length - 10, 10)
		movies
	end
end