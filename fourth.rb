require 'ostruct'
require 'csv'
require 'date'
file_name = ARGV.first || "../movies.txt"
raise "File \"#{file_name}\" not found" unless File.exist? file_name

movies = CSV.read(file_name, col_sep: "|", headers: ['url', 'title', 'year', 
																										'country', 'date', 'genre', 
																										'duration', 'rating', 'director',
																										 'actors']).map{|movie| OpenStruct.new(movie.to_hash)}

# 5 самых длинных фильмов					
puts movies.
	sort_by{|movie| movie.duration.split(' ').
	map(&:to_i)}.reverse[0..5].
	map {|movie| "Продолжительность: #{movie.duration} Название: #{movie.title}"}
# все комедии, отсортированные по дате выхода
puts movies.
	select{|movie| movie.genre.split(',').include? "Comedy"}.
	sort_by(&:date).
	map {|movie| "Дата выхода: #{movie.date} Название: #{movie.title}"}
# список всех режиссёров по алфавиту (без повторов!)
puts movies.map(&:director).uniq.sort_by{|director| director.split.last}
# количество фильмов, снятых не в США.
# вывел страна + название, а после этого количество фильмов
puts movies.reject{|movie| movie.country == 'USA'}.
	sort_by(&:country).
	map{|movie| puts "Страна: #{movie.country} Название: #{movie.title}"}.count
# Вывести количество фильмов, сгруппированных по режиссёру, использовать метод group by
puts movies.
	group_by(&:director).
	map {|director, dirmovies| "Кол-во фильмов: #{dirmovies.count} Режиссер: #{director}"}
# Вывести количество фильмов, в котором снялся каждый актёр, использовать метод reduce
puts movies.
	map { |movie| movie.actors.split(',') }.
	flatten.reduce(Hash.new(0)) { |actors_hash, x| actors_hash[x] += 1; actors_hash }.
	map{ |actor| "Имя: #{actor[0].strip} Кол-во фильмов:#{actor[1]}"}
#Вывести статистику по месяцам — в каком сколько фильмов снято (вне зависимости от года)
puts movies.select { |movie|  movie.date.include? '-' }.
	map{ |movie| Date.strptime(movie.date,'%Y-%m')}.group_by(&:mon).
	sort.map { |month, movies| "Месяц:#{Date::MONTHNAMES[month]} Кол-во фильмов:#{movies.count}" }
	
