def print_films(data)
  data.each do |value|
    puts '_____________________'
    puts "Фильм: #{value.title} - #{value.description}"
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
  data.each do |name, count|
    puts "#{name}  Кол-во:#{count}\n"
  end
end