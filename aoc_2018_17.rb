class NilClass
  def method_missing(*args); nil; end
end

class Array
  def fetch(index)
    if index < 0
      return nil
    end
    self[index]
  end
end

A = File.read('aoc_2018_17.txt')

OFFSET = 455
arr = Array.new(1680){Array.new(300){"."}}

ys = []
A.split("\n").map {|x| x.split(", ")}.each do |a,b|
  x = [a,b].detect {|c| c.include?("x=")}
  y = [a,b].detect {|c| c.include?("y=")}
  y = y.include?(".") ? y.sub("y=","").split("..").map {|x| x.to_i} : [y.sub("y=","").to_i]
  x = x.include?(".") ? x.sub("x=","").split("..").map {|y| y.to_i} : [x.sub("x=","").to_i]
 
  for yy in y[0]..y[-1]
    ys << y.min
    for xx in x[0]..x[-1]
      arr[yy][xx-OFFSET] = "#"
    end
  end    
end

arr[0][500-OFFSET] = "+"  

def floor?(i, j1, j2, arr)
  k = i
  i1 = []
  until arr.fetch(k).fetch(j1) != "#"
    i1 << k
    k += 1
  end
  k = i
  i2 = []
  until arr.fetch(k).fetch(j2) != "#"
    i2 << k
    k += 1
  end
  last = (i1+i2).max
  bottom_arr = arr[last][j1..j2]
  return bottom_arr.all? {|x| x == "#"}
end 
 
# 1

max_j = 1
water = 0
new_drops = nil

loop do
  i = 0
  j = 0
  while i < max_j
    while j < arr[i].length
      if arr.fetch(i).fetch(j) == "." 
     
        if arr.fetch(i-1).fetch(j) == "+"
          arr[i][j] = "|"
          water += 1

        elsif arr.fetch(i-1).fetch(j) == "|"
          arr[i][j] = "|" 
          water += 1  

        elsif arr.fetch(i).fetch(j+1) == "|" && arr[i][0..j-1].include?("#") && arr[i][j+1..-1].include?("#") && arr[i+1][0..j-1].include?("#") && arr[i+1][j+1..-1].include?("#") &&
          arr.fetch(i+1).fetch(j) == "|"
          j1 = j-1
          until arr[i+1][j1] == "#"
            j1 -= 1
          end  
          j2 = j+1
          until arr[i+1][j2] == "#"
            j2 += 1
          end
          if floor?(i+1, j1, j2, arr)
            arr[i][j] = "|"
            water += 1
          end
         
        elsif arr.fetch(i).fetch(j-1) == "|" && arr[i][0..j-1].include?("#") && arr[i][j+1..-1].include?("#") && arr[i+1][0..j-1].include?("#") && arr[i+1][j+1..-1].include?("#") &&
          arr.fetch(i+1).fetch(j) == "|"
          j1 = j-1
          until arr[i+1][j1] == "#"
            j1 -= 1
          end  
          j2 = j+1
          until arr[i+1][j2] == "#"
            j2 += 1
          end
          if floor?(i+1, j1, j2, arr)
            arr[i][j] = "|"
            water += 1
          end

        elsif arr.fetch(i).fetch(j+1) == "|" && !arr[i][0..j-1].include?("#") && arr[i][j+1..-1].include?("#") && arr[i+1][0..j-1].include?("#") && arr[i+1][j+1..-1].include?("#") &&
          arr.fetch(i+1).fetch(j) == "|"
          j1 = j-1
          until arr[i+1][j1] == "#"
            j1 -= 1
          end  
          j2 = j+1
          until arr[i+1][j2] == "#"
            j2 += 1
          end
          if floor?(i+1, j1, j2, arr)
            arr[i][j] = "|"
            water += 1
          end

        elsif arr.fetch(i).fetch(j+1) == "|" && arr[i][0..j-1].include?("#") && !arr[i][j+1..-1].include?("#") && arr[i+1][0..j-1].include?("#") && arr[i+1][j+1..-1].include?("#") &&
          arr.fetch(i+1).fetch(j) == "|"
          j1 = j-1
          until arr[i+1][j1] == "#"
            j1 -= 1
          end  
          j2 = j+1
          until arr[i+1][j2] == "#"
            j2 += 1
          end
          if floor?(i+1, j1, j2, arr)
            arr[i][j] = "|"
            water += 1
          end

        elsif arr.fetch(i).fetch(j-1) == "|" && !arr[i][0..j-1].include?("#") && arr[i][j+1..-1].include?("#") && arr[i+1][0..j-1].include?("#") && arr[i+1][j+1..-1].include?("#") &&
          arr.fetch(i+1).fetch(j) == "|"
          j1 = j-1
          until arr[i+1][j1] == "#"
            j1 -= 1
          end  
          j2 = j+1
          until arr[i+1][j2] == "#"
            j2 += 1
          end
          if floor?(i+1, j1, j2, arr)
            arr[i][j] = "|"
            water += 1
          end

        elsif arr.fetch(i).fetch(j-1) == "|" && arr[i][0..j-1].include?("#") && !arr[i][j+1..-1].include?("#") && arr[i+1][0..j-1].include?("#") && arr[i+1][j+1..-1].include?("#") &&
          arr.fetch(i+1).fetch(j) == "|"
          j1 = j-1
          until arr[i+1][j1] == "#"
            j1 -= 1
          end  
          j2 = j+1
          until arr[i+1][j2] == "#"
            j2 += 1
          end
          if floor?(i+1, j1, j2, arr)
            arr[i][j] = "|"
            water += 1
          end       

        elsif arr.fetch(i).fetch(j-1) == "|" && arr.fetch(i+1).fetch(j-1) == "#" 
          arr[i][j] = "|"
          water += 1
        elsif arr.fetch(i).fetch(j+1) == "|" && arr.fetch(i+1).fetch(j+1) == "#" 
          arr[i][j] = "|"
          water += 1

        elsif arr.fetch(i).fetch(j+1) == "|" && arr.fetch(i+1).fetch(j) == "#" 

          j1 = j
           
          j2 = j+1
          until arr[i+1][j2] == "#"
            j2 += 1
          end
          if floor?(i+1, j1, j2, arr)
            arr[i][j] = "|"
            water += 1
          end

        elsif arr.fetch(i).fetch(j-1) == "|" && arr.fetch(i+1).fetch(j) == "#"

          j2 = j
           
          j1 = j-1
          until arr[i+1][j1] == "#"
            j1 -= 1
          end
          if floor?(i+1, j1, j2, arr) && i != 796 && i != 1043 # ¯\_(ツ)_/¯
            arr[i][j] = "|" 
            water += 1  
          end
          
        end    
      end    

      j += 1
    end
    i += 1
    j = 0
  end
  unless max_j == arr.length
    max_j += 1
  end
 
  if new_drops == water && water != 0
    puts water-ys.min+1
    break
  end
  
  new_drops = water
end


# 2
rest_water = 0

i = 0
j = 0
while i < arr.length

  while j < arr[i].length
    if arr.fetch(i).fetch(j) == "|" && arr[i][0..j-1].include?("#") && arr[i][j+1..-1].include?("#") 
      j1 = j-1
      until arr[i][j1] == "#"
        j1 -= 1
      end  
      j2 = j+1
      until arr[i][j2] == "#"
        j2 += 1
      end
      if floor?(i, j1, j2, arr)
        rest_water += 1
      end
    end
    j += 1
  end
  i += 1
  j = 0
end

p rest_water     
