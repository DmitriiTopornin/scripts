file_name = ARGV.first || "movies.txt"
raise "File \"#{file_name}\" not found" unless File.exist? file_name
movies = File.readlines(file_name).map {|movie| movie = movie.split('|'); {url: movie[0], title: movie[1],
																																						year: movie[2], country: movie[3],
																																					  date: movie[4], genre: movie[5], 
																																					  duration: movie[6], rating: movie[7],
																																					  director: movie[8], actors: movie[9]} }
# 5 самых длинных фильмов
puts movies.
	sort_by{|movie| movie[:duration].split(' ').
	map(&:to_i)}.reverse[0..5].
	map {|movie| "Продолжительность: #{movie[:duration]} Название: #{movie[:title]}"}
# все комедии, отсортированные по дате выхода
puts movies.
	select{|movie| movie[:genre].split(',').include? "Comedy"}.
	sort_by{|movie| movie[:date]}.
	map {|movie| "Дата выхода: #{movie[:date]} Название: #{movie[:title]}"}
# список всех режиссёров по алфавиту (без повторов!)
puts movies.map {|movie| movie[:director]}.uniq.sort_by{|director| director.split.last}
# количество фильмов, снятых не в США.
# вывел страна + название, а после этого количество фильмов
puts movies.reject{|movie| movie[:country] == 'USA'}.
	sort_by{|movie| movie[:country]}.
	map{|movie| puts "Страна: #{movie[:country]} Название: #{movie[:title]}"}.count
# Вывести количество фильмов, сгруппированных по режиссёру, использовать метод group by
puts movies.
	group_by {|movie| movie[:director]}.
	map {|director, dirmovies| "Кол-во фильмов: #{dirmovies.count} Режиссер: #{director}"}
# Вывести количество фильмов, в котором снялся каждый актёр, использовать метод reduce
puts movies.
	map { |movie| movie[:actors].split(',') }.
	flatten.reduce(Hash.new(0)) { |t, x| t[x] += 1; t }.
	map{ |actor| "Имя: #{actor[0].strip} Кол-во фильмов:#{actor[1]}"}