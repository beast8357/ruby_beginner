goods = {}
total_price = 0.0
product_price = 0.0

loop do
  puts "Hint: Enter \"stop\" to finish."
  puts "Enter the product name: "
  product_name = gets.chomp.to_s.downcase
  break if product_name == 'stop'
  puts "Enter the unit price: "
  unit_price = gets.chomp.to_f
  puts "Enter units amount: "
  units_amount = gets.chomp.to_f

  goods[product_name] = {
    unit_price: unit_price,
    units_amount: units_amount
  }
end

puts goods
puts ""

goods.each do |name, properties|
  product_price = properties[:unit_price] * properties[:units_amount]
  puts "#{name.capitalize} cost(s) #{product_price}$."
  total_price += product_price
end

puts ""
puts "Total price: #{total_price}$."