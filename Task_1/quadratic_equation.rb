puts "Enter coefficient \"a\": "
a = gets.chomp.to_f
puts "Enter coefficient \"b\": "
b = gets.chomp.to_f
puts "Enter coefficient \"c\": "
c = gets.chomp.to_f
discriminant = b ** 2 - 4 * a * c

if discriminant < 0
	puts "The discriminant is #{discriminant}."
	puts "There are no roots."
else 
	first_root = (-b - Math.sqrt(discriminant)) / (2 * a)
	second_root = (-b + Math.sqrt(discriminant)) / (2 * a)
	if discriminant == 0
		puts "The discriminant is #{discriminant}."
		puts "The root is #{first_root}."
	elsif discriminant > 0
		puts "The discriminant is #{discriminant}."
		puts "First root is #{first_root}."
		puts "Second root is #{second_root}."
	end
end
