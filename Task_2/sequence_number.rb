#У Американцев дата записывается так: сначала месяц, затем число, затем год

month_numbers_and_days = {
	1 => 31,
	2 => 28,
	3 => 31,
	4 => 30,
	5 => 31,
	6 => 30,
	7 => 31,
	8 => 31,
	9 => 30,
	10 => 31,
	11 => 30,
	12 => 31
}

sequence_number = 0

puts "Enter day number: "
day_number = gets.chomp.to_i.abs
until (1..31).include?(day_number)
	unless (1..31).include?(day_number)
		puts "The date should be in range from 1 to 31!"
		puts "Enter date again: "
		day_number = gets.chomp.to_i.abs
		break if (1..31).include?(day_number)
	end
end

puts "Enter month: "
month_number = gets.chomp.to_i.abs
until (1..12).include?(month_number)
	unless (1..12).include?(month_number)
		puts "The month should be in range from 1 to 12!"
		puts "Enter month again: "
		month_number = gets.chomp.to_i.abs
		break if (1..12).include?(month_number)
	end
end

puts "Enter year: "
year = gets.chomp.to_i.abs

is_leap = false
is_leap = true if (year % 4 == 0 && year % 100 != 0) || year % 400 == 0

days_in_month = month_numbers_and_days[month_number]
days_in_month = 29 if is_leap == true && month_number == 2
if day_number > days_in_month
	puts "There are only #{days_in_month} days in month #{month_number} of year #{year}."
	exit
end

for number in (1..month_number)
	if month_number == 1
		sequence_number += day_number
		break
	else
		number != month_number ? sequence_number += month_numbers_and_days[number] :
		                         sequence_number += day_number
		number += 1
	end
end

sequence_number += 1 if is_leap == true

puts "The date sequence number is #{sequence_number}."


