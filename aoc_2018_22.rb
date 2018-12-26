DEPTH = 10689
TARGET = [11,722]

M = 20183

arr = Array.new(TARGET[1]+10){Array.new(28){"."}}

y = 0
x = 0
geo_index = {}
erosion = {}
while y < arr.length
  
  while x < arr[y].length
    if (y == 0 && x == 0) || [x,y] == TARGET
      geo_index[[y,x]] = 0
    elsif y == 0
      geo_index[[y,x]] = (x*16807)%M
    elsif x == 0 
      geo_index[[y,x]] = (y*48271)%M
    else
      geo_index[[y,x]] = (erosion[[y,x-1]]*erosion[[y-1,x]])%M
    end
    erosion[[y,x]] = (geo_index[[y,x]]+DEPTH)%M    
    x += 1
  end
  y += 1
  x = 0
end   

# 1

puts erosion.select {|(y,x),v| x <= TARGET[0] && y <= TARGET[1]}.values.map {|x| x % 3}.inject(:+)

# 2

erosion.each do |(y,x),v|
  arr[y][x] = v % 3 == 1 ? "=" : (v % 3 == 2 ? "|" : ".")
end

# http://rosettacode.org/wiki/Dijkstra%27s_algorithm#Ruby
class Graph
  Vertex = Struct.new(:name, :neighbours, :dist, :prev)

  def initialize(graph)
    @vertices = Hash.new{|h,k| h[k]=Vertex.new(k,[],Float::INFINITY)}
    @hash = {}
    graph.each do |v1,v2,dist|
      @hash[[v1,v2]] = dist
      @vertices[v1].neighbours << v2
      @vertices[v2].neighbours << v1
    end
    @dijkstra_source = nil
  end

  def dijkstra(source)
    return  if @dijkstra_source == source
    q = @vertices.values
    q.each do |v|
      v.dist = Float::INFINITY
      v.prev = nil
    end
    @vertices[source].dist = 0
    until q.empty?
      u = q.min_by {|vertex| vertex.dist}
      break if u.dist == Float::INFINITY
      q.delete(u)
      u.neighbours.each do |v|
        vv = @vertices[v]
        if q.include?(vv)
          alt = u.dist + (@hash[[u.name, v]] || 0)
          if alt < vv.dist
            vv.dist = alt
            vv.prev = u.name
          end
        end
      end
    end
    @dijkstra_source = source
  end

  def shortest_path(source, target)
    dijkstra(source)
    path = []
    u = target
    while u
      path.unshift(u)
      u = @vertices[u].prev
    end
    return path, @vertices[target].dist
  end
end

def valid_move?(m,n,o,p)
  return false if m == "." && [o,p].include?("N")
  return false if m == "|" && [o,p].include?("C")
  return false if m == "=" && [o,p].include?("T")
  return false if n == "." && p == "N"
  return false if n == "|" && p == "C"
  return false if n == "=" && p == "T"
  true
end  

w = [".","|","="]
x = ["N","C","T"]
@field_value = {}
w.repeated_permutation(2).to_a.product(x.repeated_permutation(2).to_a).map {|a,b| a+b}.each do |m,n,o,p|
  @field_value[[m,n,o,p]] = if o == p && valid_move?(m,n,o,p)
    1
  elsif o != p && valid_move?(m,n,o,p)
    8
  else
    Float::INFINITY
  end  
end

def create_graph(arrs)
  graph = []

  ["N","C","T"].repeated_permutation(2).to_a.each do |a,b|
    i, j = 0,0
    while i < arrs.length
      while j < arrs[i].length
        if j == 0 && i == 0
          graph << ["#{i}-#{j}-#{a}", "#{i}-#{j+1}-#{b}",@field_value[[arrs[i][j],arrs[i][j+1],a,b]]] 
          graph << ["#{i}-#{j}-#{a}", "#{i+1}-#{j}-#{b}",@field_value[[arrs[i][j],arrs[i+1][j],a,b]]] 
        elsif i == 0 && j < arrs[i].length-1
          graph << ["#{i}-#{j}-#{a}", "#{i+1}-#{j}-#{b}",@field_value[[arrs[i][j],arrs[i+1][j],a,b]]] 
          graph << ["#{i}-#{j}-#{a}", "#{i}-#{j+1}-#{b}",@field_value[[arrs[i][j],arrs[i][j+1],a,b]]]
          graph << ["#{i}-#{j}-#{a}", "#{i}-#{j-1}-#{b}",@field_value[[arrs[i][j],arrs[i][j-1],a,b]]]
        elsif i == 0 && j == arrs[i].length-1
          graph << ["#{i}-#{j}-#{a}", "#{i+1}-#{j}-#{b}",@field_value[[arrs[i][j],arrs[i+1][j],a,b]]] 
          graph << ["#{i}-#{j}-#{a}", "#{i}-#{j-1}-#{b}",@field_value[[arrs[i][j],arrs[i][j-1],a,b]]]
        elsif j == 0 && i < arrs.length-1
          graph << ["#{i}-#{j}-#{a}", "#{i}-#{j+1}-#{b}",@field_value[[arrs[i][j],arrs[i][j+1],a,b]]]
          graph << ["#{i}-#{j}-#{a}", "#{i+1}-#{j}-#{b}",@field_value[[arrs[i][j],arrs[i+1][j],a,b]]]
          graph << ["#{i}-#{j}-#{a}", "#{i-1}-#{j}-#{b}",@field_value[[arrs[i][j],arrs[i-1][j],a,b]]]
        elsif j == 0 && i == arrs.length-1
          graph << ["#{i}-#{j}-#{a}", "#{i}-#{j+1}-#{b}",@field_value[[arrs[i][j],arrs[i][j+1],a,b]]]
          graph << ["#{i}-#{j}-#{a}", "#{i-1}-#{j}-#{b}",@field_value[[arrs[i][j],arrs[i-1][j],a,b]]]
        elsif i == arrs.length-1 && j > 0
          graph << ["#{i}-#{j}-#{a}", "#{i}-#{j+1}-#{b}",@field_value[[arrs[i][j],arrs[i][j+1],a,b]]]
          graph << ["#{i}-#{j}-#{a}", "#{i}-#{j-1}-#{b}",@field_value[[arrs[i][j],arrs[i][j-1],a,b]]]
          graph << ["#{i}-#{j}-#{a}", "#{i-1}-#{j}-#{b}",@field_value[[arrs[i][j],arrs[i-1][j],a,b]]]
        elsif j == arrs[i].length-1 && i > 0
          graph << ["#{i}-#{j}-#{a}", "#{i+1}-#{j}-#{b}",@field_value[[arrs[i][j],arrs[i+1][j],a,b]]]
          graph << ["#{i}-#{j}-#{a}", "#{i}-#{j-1}-#{b}",@field_value[[arrs[i][j],arrs[i][j-1],a,b]]]
          graph << ["#{i}-#{j}-#{a}", "#{i-1}-#{j}-#{b}",@field_value[[arrs[i][j],arrs[i-1][j],a,b]]]
        else
          graph << ["#{i}-#{j}-#{a}", "#{i+1}-#{j}-#{b}",@field_value[[arrs[i][j],arrs[i+1][j],a,b]]]
          graph << ["#{i}-#{j}-#{a}", "#{i-1}-#{j}-#{b}",@field_value[[arrs[i][j],arrs[i-1][j],a,b]]]
          graph << ["#{i}-#{j}-#{a}", "#{i}-#{j+1}-#{b}",@field_value[[arrs[i][j],arrs[i][j+1],a,b]]]
          graph << ["#{i}-#{j}-#{a}", "#{i}-#{j-1}-#{b}",@field_value[[arrs[i][j],arrs[i][j-1],a,b]]]
        end
        j += 1
      end
      i += 1
      j = 0
    end
  end  

  graph
end 

g = Graph.new(create_graph(arr))  
  
p g.shortest_path("0-0-T", "#{TARGET[1]}-#{TARGET[0]}-T")[1]