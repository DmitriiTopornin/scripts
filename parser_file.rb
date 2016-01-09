ARGV.empty? ? file_name = "movies.txt" : file_name = ARGV.first
raise "File \"#{file_name}\" not found" unless File.exist? file_name
f = File.open(file_name, "r")
file = f.read
file_array = file.split("\n")
file_array.each do |movie|
	movie = movie.split('|')
	if movie[1].include? "Time"
		puts "#{movie[1]} " + "*" * movie[7].split('.').last.to_i
		puts '_______'
	end
end