A = File.read("aoc_2018_2.txt")

# 1

twos = 0
threes = 0

A.split("\n").each do |a|
  counts = Hash.new(0)
  a.split("").each { |l| counts[l] += 1 }
  twos += counts.values.include?(2) ? 1 : 0
  threes += counts.values.include?(3) ? 1 : 0
end

p twos*threes 

# 2 

puts A.split("\n").combination(2).to_a.detect {
  |a,b| (a.split("").each_with_index.map {
  |c,i| [c,i]} & b.split("").each_with_index.map {
  |d,i| [d,i]}).length == a.length-1}.map {
  |e| e.split("").each_with_index.map {|f,i| [f,i]}}
  .inject(:&).transpose[0].join
