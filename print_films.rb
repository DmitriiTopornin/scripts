def print_films(data)
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

def print_stats(data)
  data.each do |value_hash|
    puts "#{value_hash[0]}  Кол-во:#{value_hash[1]}\n"
  end
end