require_relative 'movie'
require 'ostruct'
require 'csv'
require 'date'

COLUMNS = %w[url title year country date genre duration rating director actors]

class MoviesList
	def initialize(file_name = '../movies.txt')
		csv_parse(file_name)
	end

	def csv_parse(file_name = '../movies.txt')
		raise "File \"#{file_name}\" not found" unless File.exist? file_name
		@movies = CSV.read(file_name, col_sep: "|", headers: COLUMNS).
			map{|movie| Movie.new(movie.to_hash)}
	end

	def include_genre(ingenre)
		puts "Все фильмы с жанром '#{ingenre}'"
		@movies.select{|movie| movie.genre.include?(ingenre)}.map {|movie| "Фильм:#{movie.title} | Жанр:#{movie.genre}"}
	end

	def exclude_genre(exgenre)		
		puts "Все фильмы кроме жанра '#{exgenre}'"
		@movies.reject{|movie| movie.genre.include?(exgenre)}.map {|movie| "Фильм:#{movie.title} | Жанр:#{movie.genre}"}
	end

	def sort_by(field)
		if @movies.first.instance_variables.map{|s| s.to_s.delete("@")}.include? field
			puts "Сортировка по полю #{field}"
			@movies.sort_by{|movie| movie.send(field)}.map {|movie| "Поле: #{movie.send(field)} | Фильм: #{movie.title}"}
		else
			"Заданного поля не существует"
		end
	end
end
