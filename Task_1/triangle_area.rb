puts "Enter the base of the triangle in meters: "
base = gets.chomp.to_f
puts "Enter the height of the triangle in meters: "
height = gets.chomp.to_f
triangle_area = 0.5 * base * height
puts "The area of the triangle is #{triangle_area} square meters."