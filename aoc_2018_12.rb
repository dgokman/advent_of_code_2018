initial = "..........#.#.#...#..##..###.##.#...#.##.#....#..#.#....##.#.##...###.#...#######.....##.###.####.#....#.#..##....." << "."*500

rules = "#...# => #
....# => .
##..# => #
.#.## => #
##.## => .
###.# => #
..... => .
...#. => .
.#.#. => #
#.##. => #
..#.# => #
.#... => #
#.#.. => .
##.#. => .
.##.. => #
#..#. => .
.###. => .
..#.. => .
#.### => .
..##. => .
.#..# => #
.##.# => .
.#### => .
...## => #
#.#.# => #
..### => .
#..## => .
####. => #
##### => .
###.. => #
##... => #
#.... => ."

require 'set'
arr = initial.split("")
rules = rules.split("\n").map {|a| a.split(" => ")}

20.times do |z|
  changed = Set.new
  rules.each do |rule|
    initial.split("").each_cons(5).each_with_index do |plants, i|
      if rule.first == plants.join && rule.last == "#"
        arr[i+2] = "#"
        changed << i+2 
      end  
    end    
  end
  for j in 0..arr.length-1
    if arr[j] == "#" && !changed.include?(j)
      arr[j] = "."
    end  
  end    

  initial = arr.join
  arr = initial.split("")
end 

p arr.each_with_index.map { |a,i| a == "#" ? i-10 : 0 }.inject(:+)

# 2

# values start increasing by 59 at time 102

# 101 7557 116
# 102 7616 59
# 103 7675 59
# 104 7734 59
# 105 7793 59
# 106 7852 59
# 107 7911 59
# 108 7970 59
# 109 8029 59

p 7616+(5*10**8-102)*59 
