A = File.read("aoc_2018_1.txt")

# 1 

puts A.split("\n").map(&:to_i).inject(:+)

# 2

require 'set'
arr = Set.new
freq = 0
duplicate = nil

until duplicate
  A.split("\n").map(&:to_i).each do |a|
    freq += a
    if arr.include?(freq)
      duplicate = freq
      break
    end  
    arr << freq
  end  
end  

p duplicate




