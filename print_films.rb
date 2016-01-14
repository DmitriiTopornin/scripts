def print_films(data)
  if data.first.is_a? String 
    puts '_____________________'
      data.map {|value| puts value}
    puts '_____________________'
  elsif data.is_a? Hash
  	puts '_____________________'
  	data.each do |value_hash|
  		puts "#{value_hash[0]} => #{value_hash[1]}\n"
  	end
  	puts '_____________________'
  else
  data.each do |value|
  	puts '_____________________'
    puts "Фильм: #{value.title}"
    puts "Жанр: #{value.genre}"
    puts "Страна: #{value.country}"
    puts "Рейтинг: #{value.rating}"
    puts "Продолжительность: #{value.duration}"
    puts "Дата выхода: #{value.date}"
    puts "Режиссер: #{value.director}"
    puts "Актерский состав: #{value.actors}"
    puts '_____________________'
  end
 	end
end