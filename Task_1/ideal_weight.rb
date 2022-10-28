puts "What's your name?"
name = gets.chomp
puts "What's your height?"
height = gets.chomp.to_i
ideal_weight = (height - 110) * 1.15
if ideal_weight >= 0
	puts "#{name}, your ideal weight is #{ideal_weight}."
else
	puts "#{name}, your weight is already good!"
end