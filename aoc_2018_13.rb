A = File.read('aoc_2018_13.txt')
  
require 'set'

class Array
  def fetch(index)
    if index < 0
      return nil
    end
    self[index]
  end
end

@initial = A.split("\n").map {|x| x.split("")}.reject {|a| !a.any?}

def replace(y,x)
  if @initial[y][x] == "v" || @initial[y][x] == "^"
    return "|"
  elsif @initial[y][x] == ">" || @initial[y][x] == "<"
    return "-"
  else
    return @initial[y][x]
  end
end      

hash = {}
dir_hash = {}
count = 0

arr = Marshal.load(Marshal.dump(@initial))

y = 0
x = 0
while y < arr.length
  while x < arr[y].length
    
    if ["^",">","<","v"].include?(@initial.fetch(y).fetch(x))
      dir_hash[[y,x]] = "L"
      count += 1
      
    end  
    x += 1
  end
  y += 1
  x = 0
end

solved_1 = false
loop do

  new_arr = Marshal.load(Marshal.dump(arr))
  
  y = 0
  x = 0
  while y < arr.length
    while x < arr[y].length
      
      if ["^",">","<","v"].include?(arr.fetch(y).fetch(x))
        hash[[y,x]] = arr[y][x]
        
      end  
      x += 1
    end
    y += 1
    x = 0
  end
  
  if hash.length == 1
    # 2
    puts hash.keys.first.reverse.map {|x| x.to_s}.join(",")
    break
  end 

  crashed = Set.new

  hash.keys.sort.combination(2).each do |(a,b),(c,d)|
    if (c-a == 2 && b-d == 0 && hash[[a,b]] == "v" && hash[[c,d]] == "^") ||
      (a-c == 2 && b-d == 0 && hash[[c,d]] == "v" && hash[[a,b]] == "^") ||
      (d-b == 2 && a-c == 0 && hash[[a,b]] == ">" && hash[[c,d]] == "<") ||
      (b-d == 2 && a-c == 0 && hash[[a,b]] == "<" && hash[[c,d]] == ">") ||
      (c-a == 1 && d-b == 1 && hash[[a,b]] == "v" && hash[[c,d]] == "<") ||
      (a-c == 1 && b-d == 1 && hash[[c,d]] == "v" && hash[[a,b]] == "<") ||
      (d-b == 1 && c-a == 1 && hash[[a,b]] == ">" && hash[[c,d]] == "^") ||
      (b-d == 1 && a-c == 1 && hash[[c,d]] == ">" && hash[[c,d]] == "^")

      if !solved_1
        # 1
        v1 = (a-c).abs
        v2 = (b-d).abs
        if v1 == 2
          puts "#{b},#{[a,c].sort.first+1}"
        else
          puts "#{[b,d].sort.first+1},#{a}" 
        end
        solved_1 = true
      end     

      new_arr[a][b] = replace(a,b)
      new_arr[c][d] = replace(c,d) 
    end    
  end

  arr = Marshal.load(Marshal.dump(new_arr)) 
  
  hash.sort_by {|k,v| k}.each do |(y,x), v|
       
    if arr.fetch(y).fetch(x) == ">" && arr.fetch(y).fetch(x+1) == "L"
      new_arr[y][x] = replace(y,x)
      unless hash.keys.include?([y,x+1]) || crashed.include?([y,x])
        new_arr[y][x+1] = "v" 
      else
        new_arr[y][x+1] = replace(y,x+1)
        crashed << [y,x+1]
      end     

      dir_hash[[y,x+1]] = dir_hash[[y,x]]
    elsif arr.fetch(y).fetch(x) == ">" && arr.fetch(y).fetch(x+1) == "/"
      new_arr[y][x] = replace(y,x)
      unless hash.keys.include?([y,x+1]) || crashed.include?([y,x])
        new_arr[y][x+1] = "^" 
      else
        new_arr[y][x+1] = replace(y,x+1)
        crashed << [y,x+1]
      end  
          
      dir_hash[[y,x+1]] = dir_hash[[y,x]]
    elsif arr.fetch(y).fetch(x) == ">" && arr.fetch(y).fetch(x+1) == "+"
      new_arr[y][x] = replace(y,x)
      
      if dir_hash[[y,x]] == "L"
        unless hash.keys.include?([y,x+1]) || crashed.include?([y,x])
          new_arr[y][x+1] = "^" 
        else
          new_arr[y][x+1] = replace(y,x+1)
          crashed << [y,x+1]
        end    
        dir_hash[[y,x+1]] = "S"
      elsif dir_hash[[y,x]] == "S"
        unless hash.keys.include?([y,x+1]) || crashed.include?([y,x])
          new_arr[y][x+1] = ">" 
        else
          new_arr[y][x+1] = replace(y,x+1)
          crashed << [y,x+1]
        end    
        dir_hash[[y,x+1]] = "R"
      elsif dir_hash[[y,x]] == "R"
        unless hash.keys.include?([y,x+1]) || crashed.include?([y,x])
          new_arr[y][x+1] = "v" 
        else
          new_arr[y][x+1] = replace(y,x+1)
          crashed << [y,x+1]
        end    
        dir_hash[[y,x+1]] = "L"
      end

    elsif arr.fetch(y).fetch(x) == ">"
      new_arr[y][x] = replace(y,x)
      unless hash.keys.include?([y,x+1]) || crashed.include?([y,x])
        new_arr[y][x+1] = ">" 
      else
        new_arr[y][x+1] = replace(y,x+1)
        crashed << [y,x+1]
      end   

      dir_hash[[y,x+1]] = dir_hash[[y,x]] 


    elsif arr.fetch(y).fetch(x) == "<" && arr.fetch(y).fetch(x-1) == "L"
      new_arr[y][x] = replace(y,x)
      unless hash.keys.include?([y,x-1]) || crashed.include?([y,x])
        new_arr[y][x-1] = "^" 
      else
        new_arr[y][x-1] = replace(y,x-1)
        crashed << [y,x-1]
      end    

      dir_hash[[y,x-1]] = dir_hash[[y,x]]
    elsif arr.fetch(y).fetch(x) == "<" && arr.fetch(y).fetch(x-1) == "/"
      new_arr[y][x] = replace(y,x)
      unless hash.keys.include?([y,x-1]) || crashed.include?([y,x])
        new_arr[y][x-1] = "v"
      else
        new_arr[y][x-1] = replace(y,x-1)
        crashed << [y,x-1]
      end     

      dir_hash[[y,x-1]] = dir_hash[[y,x]]
    elsif arr.fetch(y).fetch(x) == "<" && arr.fetch(y).fetch(x-1) == "+"
      new_arr[y][x] = replace(y,x)
      
      if dir_hash[[y,x]] == "L" 
        unless hash.keys.include?([y,x-1]) || crashed.include?([y,x])
          new_arr[y][x-1] = "v" 
        else
          new_arr[y][x-1] = replace(y,x-1)
          crashed << [y,x-1]
        end    
        dir_hash[[y,x-1]] = "S"
      elsif dir_hash[[y,x]] == "S"
        unless hash.keys.include?([y,x-1]) || crashed.include?([y,x])
          new_arr[y][x-1] = "<"
        else
          new_arr[y][x-1] = replace(y,x-1)
          crashed << [y,x-1]
        end    
        dir_hash[[y,x-1]] = "R"
      elsif dir_hash[[y,x]] == "R"
        unless hash.keys.include?([y,x-1]) || crashed.include?([y,x])
          new_arr[y][x-1] = "^" 
        else
          new_arr[y][x-1] = replace(y,x-1)
          crashed << [y,x-1]
        end   
        dir_hash[[y,x-1]] = "L"
      end

    elsif arr.fetch(y).fetch(x) == "<"
      new_arr[y][x] = replace(y,x)
      unless hash.keys.include?([y,x-1]) || crashed.include?([y,x])
        new_arr[y][x-1] = "<" 
      else
        new_arr[y][x-1] = replace(y,x-1)
        crashed << [y,x-1]
      end    

      dir_hash[[y,x-1]] = dir_hash[[y,x]]


    elsif arr.fetch(y).fetch(x) == "v" && arr.fetch(y+1).fetch(x) == "L"
      new_arr[y][x] = replace(y,x)
      unless hash.keys.include?([y+1,x]) || crashed.include?([y,x])
        new_arr[y+1][x] = ">" 
      else
        new_arr[y+1][x] = replace(y+1,x) 
        crashed << [y+1,x]
      end  

      dir_hash[[y+1,x]] = dir_hash[[y,x]]
    elsif arr.fetch(y).fetch(x) == "v" && arr.fetch(y+1).fetch(x) == "/"
      new_arr[y][x] = replace(y,x)
      unless hash.keys.include?([y+1,x]) || crashed.include?([y,x])
        new_arr[y+1][x] = "<" 
      else
        new_arr[y+1][x] = replace(y+1,x)
        crashed << [y+1,x]
      end   

      dir_hash[[y+1,x]] = dir_hash[[y,x]]
    elsif arr.fetch(y).fetch(x) == "v" && arr.fetch(y+1).fetch(x) == "+"
      new_arr[y][x] = replace(y,x)
      
      if dir_hash[[y,x]] == "R"
        unless hash.keys.include?([y+1,x]) || crashed.include?([y,x])
          new_arr[y+1][x] = "<" 
        else
          new_arr[y+1][x] = replace(y+1,x)
          crashed << [y+1,x]
        end    
        dir_hash[[y+1,x]] = "L"
      elsif dir_hash[[y,x]] == "L"
        unless hash.keys.include?([y+1,x]) || crashed.include?([y,x])
          new_arr[y+1][x] = ">" 
        else
          new_arr[y+1][x] = replace(y+1,x)
          crashed << [y+1,x]
        end  
        dir_hash[[y+1,x]] = "S"
      else
        unless hash.keys.include?([y+1,x]) || crashed.include?([y,x])
          new_arr[y+1][x] = "v" 
        else
          new_arr[y+1][x] = replace(y+1,x)
          crashed << [y+1,x]
        end    
        dir_hash[[y+1,x]] = "R"
      end  
 
    elsif arr.fetch(y).fetch(x) == "v"
      new_arr[y][x] = replace(y,x)
      unless hash.keys.include?([y+1,x]) || crashed.include?([y,x])
        new_arr[y+1][x] = "v" 
      else
        new_arr[y+1][x] = replace(y+1,x)
        crashed << [y+1,x]
      end    

      dir_hash[[y+1,x]] = dir_hash[[y,x]]


    elsif arr.fetch(y).fetch(x) == "^" && arr.fetch(y-1).fetch(x) == "L"
      new_arr[y][x] = replace(y,x)
      unless hash.keys.include?([y-1,x]) || crashed.include?([y,x])
        new_arr[y-1][x] = "<" 
      else
        new_arr[y-1][x] = replace(y-1,x)
        crashed << [y-1,x]
      end  

      dir_hash[[y-1,x]] = dir_hash[[y,x]]
    elsif arr.fetch(y).fetch(x) == "^" && arr.fetch(y-1).fetch(x) == "/"
      new_arr[y][x] = replace(y,x)
      unless hash.keys.include?([y-1,x]) || crashed.include?([y,x])
        new_arr[y-1][x] = ">" 
      else
        new_arr[y-1][x] = replace(y-1,x)
        crashed << [y-1,x]
      end    

      dir_hash[[y-1,x]] = dir_hash[[y,x]]
    elsif arr.fetch(y).fetch(x) == "^" && arr.fetch(y-1).fetch(x) == "+"
      new_arr[y][x] = replace(y,x)
      
      if dir_hash[[y,x]] == "R"
        unless hash.keys.include?([y-1,x]) || crashed.include?([y,x])
          new_arr[y-1][x] = ">" 
        else
          new_arr[y-1][x] = replace(y-1,x)
          crashed << [y-1,x]
        end  

        dir_hash[[y-1,x]] = "L"
      elsif dir_hash[[y,x]] == "L"
        unless hash.keys.include?([y-1,x]) || crashed.include?([y,x])
          new_arr[y-1][x] = "<" 
        else
          new_arr[y-1][x] = replace(y-1,x)
          crashed << [y-1,x]
        end   
        dir_hash[[y-1,x]] = "S"
      else
        unless hash.keys.include?([y-1,x]) || crashed.include?([y,x])
          new_arr[y-1][x] = "^" 
        else
          new_arr[y-1][x] = replace(y-1,x)
          crashed << [y-1,x]
        end    
        dir_hash[[y-1,x]] = "R"
      end  

    elsif arr.fetch(y).fetch(x) == "^"
      new_arr[y][x] = replace(y,x)
      unless hash.keys.include?([y-1,x]) || crashed.include?([y,x])
        new_arr[y-1][x] = "^" 
      else
        new_arr[y-1][x] = replace(y-1,x)
        crashed << [y-1,x]
      end   

      dir_hash[[y-1,x]] = dir_hash[[y,x]]
    end

    dir_hash.delete([y,x])

  end

  crashed = Set.new
  arr = Marshal.load(Marshal.dump(new_arr))  
  hash = {}
end