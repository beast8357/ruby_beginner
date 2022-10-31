vowels = {}
alphabet = ('a'..'z').to_a
alphabet.each.with_index(1) do |letter, index|
  vowels[letter] = index if ['a', 'e', 'u', 'i', 'o'].include?(letter)
end
binding.irb
puts vowels