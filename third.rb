file_name = ARGV.first || "movies.txt"
raise "File \"#{file_name}\" not found" unless File.exist? file_name
f = File.open(file_name)
file = f.read
file_array = file.split("\n")
movies ||= []
file_array.each do |movie|
	movie = movie.split('|')
	movies << mv = {url: movie[0], title: movie[1], year: movie[2], country: movie[3],
			  date: movie[4], genre: movie[5], duration: movie[6], rating: movie[7],
			  director: movie[8], actors: movie[9]}
end	
# 5 самых длинных фильмов
puts movies.sort_by{|movie| movie[:duration].split(' ').map(&:to_i)}.reverse[0..5].map {|movie| "Продолжительность: #{movie[:duration]} Название: #{movie[:title]}"}
# все комедии, отсортированные по дате выхода
puts movies.select{|movie| movie[:genre].split(',').include? "Comedy"}.sort_by{|movie| movie[:date]}.map {|movie| "Дата выхода: #{movie[:date]} Название: #{movie[:title]}"}
# список всех режиссёров по алфавиту (без повторов!)
puts movies.uniq {|movie| movie[:director]}.sort_by{|movie| movie[:director]}.map {|movie| movie[:director]}
# количество фильмов, снятых не в США.
# вывел страна + название, а после этого количество фильмов
puts movies.reject{|movie| movie[:country] == 'USA'}.sort_by{|movie| movie[:country]}.map{|movie| puts "Страна: #{movie[:country]} Название: #{movie[:title]}"}.count
# Вывести количество фильмов, сгруппированных по режиссёру, использовать метод group by
puts movies.group_by {|movie| movie[:director]}.map {|dirmovie| "Кол-во фильмов: #{dirmovie[1].count} Режиссер: #{dirmovie[0]}"}
# Вывести количество фильмов, в котором снялся каждый актёр, использовать метод reduce
actors ||= []
movies.map { |movie| movie[:actors].split(',').map {|actor| actors << actor} }
actors.reduce(Hash.new(0)) { |total, x| total[x] += 1; total.each {|key, count| puts "Имя:#{key} Кол-во фильмов:#{count}"}}