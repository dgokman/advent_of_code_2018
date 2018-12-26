A = File.read('aoc_2018_23.txt')

# 1

arr = A.split("\n").map {|x| x.split(",")}.map {|a,b,c,d| [a.sub("pos=<","").to_i,b.to_i, c.to_i, d.sub("r=","").to_i]}

max = arr.transpose[3].max
a,b,c,_ = arr.detect {|a,b,c,d| d == max}

p arr.count {|e,f,g,_| (a-e).abs + (b-f).abs + (c-g).abs <= max }

# 2

# plug in numbers until a max count is found, then subtract until count is less than max count

count = 0
max = 0

a1 = 22635071
b1 = 44907980
c1 = 12619612

loop do
  arr.each do |a,b,c,d|
    if (a-a1).abs+(b-b1).abs + (c-c1).abs <= d
      count += 1
    end
  end

  break if count < 740
  max = count
  count = 0
  c1 -= 1
end

p a1+b1+c1+1
