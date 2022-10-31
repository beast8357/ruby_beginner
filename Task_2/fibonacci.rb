fibonacci_numbers = [0, 1]
next_number = 0
index = 1
loop do
	next_number = fibonacci_numbers[index] + fibonacci_numbers[index - 1]
	break if next_number > 100
	fibonacci_numbers.push(next_number)
	index += 1
end
binding.irb
puts fibonacci_numbers