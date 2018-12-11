SERIAL = 9445

@grid = Array.new(300){Array.new(300)}

def power_level(x, y)
  rack_id = x+10
  pl = rack_id*y
  pl += SERIAL
  pl *= rack_id
  pl = pl.to_s.length >= 3 ? pl.to_s[-3].to_i : 0
  pl -= 5
end  

for y in 1..300
  for x in 1..300
    pl = power_level(x,y)
    @grid[y-1][x-1] = pl
  end
end

@hash = {}

def add_to_hash(size)
  @grid.each_with_index do |a, y|
    next if y > @grid.length-size
    a.each_cons(size).each_with_index do |b, x|
      sum = 0
      next if x > @grid.length-size
      size.times do |n|
        size.times do |o|
          sum += @grid[y+n][x+o]
        end
      end    
      @hash[[x+1,y+1]] = sum
    end
  end
end

add_to_hash(3)

p @hash.sort_by {|k,v| -v}.first.first

# 2

@hash = {}
 
max = 0
for size in 3..20
  add_to_hash(size)
  size_coordinates, size_max = @hash.sort_by {|k,v| -v}.first
  puts "#{size} #{size_max} #{size_coordinates}" 
  @hash = {}
end  
