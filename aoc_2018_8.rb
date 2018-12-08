A = File.read("aoc_2018_8.txt")
# 1 

meta_data = 0
data = A.split(" ").map(&:to_i)

i = 0
loop do
  until data[i] == 0
    i += 2
  end
  meta_data += data[i+2..i+2+data[i+1]-1].inject(:+)
  data[i..i+2+data[i+1]-1] = nil
  if i == 0
    puts meta_data
    break
  end  
  data[i-2] -= 1
  data = data.compact
  i = 0
end  

# 2

data = A.split(" ").map {|a| [a.to_i,[]]}

i = 0
loop do
  until data[i][0] == 0
    i += 2
  end
  if data[i][1].empty?
    nodes_val = data[i+2..i+2+data[i+1][0]-1].transpose[0].inject(:+)
    data[i-2][1] << nodes_val.to_i
  else
    nodes_arr = data[i][1]
    nodes_val = 0
    for j in i+2..i+2+data[i+1][0]-1
      data[j][0] = nodes_arr[data[j][0]-1].to_i
      nodes_val += data[j][0]  
    end
    if i-2 >= 0
      data[i-2][1] << nodes_val
    end
  end  

  if i == 0
    puts data[2..-1].transpose[0].inject(:+)
    break
  end 
  
  data[i-2][0] -= 1
 
  data[i..i+2+data[i+1][0]-1] = nil 
  data = data.compact

  i = 0
end


