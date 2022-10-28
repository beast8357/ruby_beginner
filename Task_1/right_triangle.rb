puts "Enter first triangle side: "
first_side = gets.chomp.to_f
puts "Enter second triangle side: "
second_side = gets.chomp.to_f
puts "Enter third triangle side: "
third_side = gets.chomp.to_f

if first_side == second_side && first_side == third_side && second_side == third_side
	puts "The triangle is isosceles and equilateral."
elsif first_side == second_side || first_side == third_side || second_side == third_side
	puts "The triangle is isosceles."
elsif first_side ** 2 == second_side ** 2 + third_side ** 2 || 
	second_side ** 2 == first_side ** 2 + third_side ** 2 || 
	third_side ** 2 == first_side ** 2 + second_side ** 2
	puts "The triangle is rectangular."
else
	puts "The triangle is neither isosceles, nor equilateral, nor rectangular."
end