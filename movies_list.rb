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

	def top_longest_films(count = 5)
		@movies.
			sort_by{|movie| movie.duration.split(' ').
			map(&:to_i)}.reverse[0..count].
			map {|movie| "Продолжительность: #{movie.duration} Название: #{movie.title}"}
	end

	def genre_date(ingenre = 'Comedy')
		@movies.
			select{|movie| movie.genre.split(',').include? ingenre}.
			sort_by(&:date).
			map {|movie| "Дата выхода: #{movie.date} Название: #{movie.title}"}
	end

	def directors_list
		@movies.map(&:director).uniq.sort_by{|director| director.split.last}
	end

	def not_from(country = 'USA')
		@movies.reject{|movie| movie.country == country}.
			sort_by(&:country).
			map{|movie| puts "Страна: #{movie.country} Название: #{movie.title}"}.count
	end

	def directors_movies_count
		@movies.
			group_by(&:director).
			map {|director, dirmovies| "Кол-во фильмов: #{dirmovies.count} Режиссер: #{director}"}
	end

	def actors_movies_count 
		@movies.
			map { |movie| movie.actors.split(',') }.
			flatten.reduce(Hash.new(0)) { |actors_hash, x| actors_hash[x] += 1; actors_hash }.
			map{ |actor| "Имя: #{actor[0].strip} Кол-во фильмов:#{actor[1]}"}
	end

	def count_by_month
		@movies.select { |movie|  movie.date.include? '-' }.
			map{ |movie| Date.strptime(movie.date,'%Y-%m')}.group_by(&:mon).
			sort.map { |month, movies| "Месяц:#{Date::MONTHNAMES[month]} Кол-во фильмов:#{movies.count}" }
	end
end
