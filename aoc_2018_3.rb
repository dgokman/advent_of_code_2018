A = File.read("aoc_2018_3.txt")

# 1

fabric = Array.new(1000){Array.new(1000){[]}}

arr = A.split("\n").map {|x| x.split(" ")}.transpose
edges = arr[2]
dimensions = arr[3]

edges.zip(dimensions).each_with_index do |(edge, dimension), i|
  y, x = edge.sub(":","").split(",")
  y, x = y.to_i, x.to_i
  width, height = dimension.split("x")
  width, height = width.to_i, height.to_i
  width.times do
    height.times do
      fabric[x][y] << i+1
      x += 1
    end 
    y += 1
    x = edge.sub(":","").split(",")[1].to_i
  end
end

puts fabric.map { |a| a.select {|arr| arr.length > 1}.map {|b| 1} }.flatten.length

# 2

puts (1..1375).to_a - fabric.map { |a| a.select {|arr| arr.length > 1} }.flatten.uniq
 
