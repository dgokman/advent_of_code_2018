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

# taken from https://github.com/brianstorti/ruby-graph-algorithms/tree/master/breadth_first_search
class Graph

  def add_edge(node_a, node_b)
    node_a.adjacents << node_b
    node_b.adjacents << node_a
  end
end

class BreadthFirstSearch
  def initialize(graph, source_node)
    @graph = graph
    @node = source_node
    @visited = []
    @edge_to = {}

    bfs(source_node)
  end

  def shortest_path_to(node)
    return unless has_path_to?(node)
    path = []

    while(node != @node) do
      path.unshift(node) # unshift adds the node to the beginning of the array
      node = @edge_to[node]
    end

    path.unshift(@node)
  end

  private
  def bfs(node)

    queue = []
    queue << node
    @visited << node

    while queue.any?
      current_node = queue.shift # remove first element
      current_node.adjacents.each do |adjacent_node|
        next if @visited.include?(adjacent_node)
        queue << adjacent_node
        @visited << adjacent_node
        @edge_to[adjacent_node] = current_node
      end
    end
  end

  def has_path_to?(node)
    @visited.include?(node)
  end
end

require "set"

class Node
  attr_accessor :name, :adjacents

  def initialize(name)
    @adjacents = Set.new
    @name = name
  end

  def to_s
    @name
  end
end

F = File.read('aoc_2018_20.txt')

map = Array.new(210){Array.new(220){"."}}


i = 110
j = 100
start = [i,j]
map[i][j] = "X"

def build_wall(i,j,map)

  map[i-1][j-1] = "#"
  map[i-1][j+1] = "#"
  map[i+1][j-1] = "#"
  map[i+1][j+1] = "#"
  map
end

def add_question_marks(i,j,map,dir)
  if dir == "E"
    map[i-1][j] = "?" unless map[i-1][j] == "|" || map[i-1][j] == "-"
    map[i][j-1] = "?" unless map[i][j-1] == "|" || map[i][j-1] == "-"
    map[i+1][j] = "?" unless map[i+1][j] == "|" || map[i+1][j] == "-"
  elsif dir == "W"
    map[i+1][j] = "?" unless map[i+1][j] == "|" || map[i+1][j] == "-"
    map[i][j+1] = "?" unless map[i][j+1] == "|" || map[i][j+1] == "-"
    map[i-1][j] = "?" unless map[i-1][j] == "|" || map[i-1][j] == "-"
  elsif dir == "N"
    map[i+1][j] = "?" unless map[i+1][j] == "|" || map[i+1][j] == "-"
    map[i][j+1] = "?" unless map[i][j+1] == "|" || map[i][j+1] == "-"
    map[i][j-1] = "?" unless map[i][j-1] == "|" || map[i][j-1] == "-"
  elsif dir == "S"
    map[i-1][j] = "?" unless map[i-1][j] == "|" || map[i-1][j] == "-"
    map[i][j+1] = "?" unless map[i][j+1] == "|" || map[i][j+1] == "-"
    map[i][j-1] = "?" unless map[i][j-1] == "|" || map[i][j-1] == "-"
  end
  map
end

def add_door(i,j,map,dir)
  if dir == "E"
    map[i][j+1] = "|"
  elsif dir == "W"
    map[i][j-1] = "|"
  elsif dir == "N"
    map[i-1][j] = "-"
  elsif dir == "S"
    map[i+1][j] = "-"
  end
  map
end

def move(i,j,dir)
  if dir == "E"
    [i,j+2]
  elsif dir == "W"
    [i,j-2]
  elsif dir == "N"
    [i-2,j]
  elsif dir == "S"
    [i+2,j]
  end
end       

init_i = nil
init_j = nil
parens = {}
nested_parens = 0
F.split("").each do |dir|

  if ["E","W","N","S"].include?(dir)
    build_wall(i,j,map)
    add_question_marks(i,j,map,dir)
    add_door(i,j,map,dir)
    i, j = move(i,j,dir)

  elsif dir == "("
    nested_parens += 1
    parens[nested_parens] = [i,j]
  elsif dir == ")"
    nested_parens -= 1
  elsif dir == "|"
    i, j = parens[nested_parens]

  end  

end

last_room = [i,j]

i = 0
j = 0
while i < map.length
  while j < map[i].length
    if map[i][j] == "?"
      map[i][j] = "#"
    end
    j += 1
  end
  i += 1
  j = 0
end

i = 0
j = 0
border = false
while i < map.length
  if map[i].all? {|x| x == "." || x == "#"}
    border = true
  end  
  while j < map[i].length
    if border
      map[i][j] = "#"
    end
    j += 1
  end
  i += 1
  border = false
  j = 0
end

def rotate(o)
  rows, cols = o.size, o[0].size
  Array.new(cols){|i| Array.new(rows){|j| o[j][cols - i - 1]}}
end

map = rotate(map)

i = 0
j = 0
border = false
while i < map.length
  if map[i].all? {|x| x == "." || x == "#"}
    border = true
  end  
  while j < map[i].length
    if border
      map[i][j] = "#"
    end
    j += 1
  end
  i += 1
  border = false
  j = 0
end

map = rotate(map)
map = rotate(map)
map = rotate(map) 

rooms = []

i = 0
j = 0
while i < map.length 
  while j < map[i].length
    if map[i][j] == "."
      rooms << [i,j]
    end 
    j += 1
  end
  i += 1
  j = 0
end 

nodes_hash = {}

i = 0
j = 0
while i < map.length 
  while j < map[i].length
    nodes_hash[[i,j]] = Node.new([i,j])
    j += 1
  end
  i += 1
  j = 0
end

graph = Graph.new
i = 0
j = 0
while i < map.length 
  while j < map[i].length
    node = nodes_hash[[i,j]]
    nodeN = nodes_hash[[i-2,j]]
    nodeS = nodes_hash[[i+2,j]]
    nodeE = nodes_hash[[i,j+2]]
    nodeW = nodes_hash[[i,j-2]]

    if map[i+1][j] == "-"
      graph.add_edge(node, nodeS)
    end
    if map[i-1][j] == "-" 
      graph.add_edge(node, nodeN)
    end
    if map[i][j+1] == "|"
      graph.add_edge(node, nodeE)
    end
    if map[i][j-1] == "|" 
      graph.add_edge(node, nodeW)
    end
    j += 1
  end
  i += 1
  j = 0
end

paths = []
# 1

rooms.each do |room|
  target = nodes_hash[room]
  len = BreadthFirstSearch.new(graph, nodes_hash[start]).shortest_path_to(target).length
  paths << len-1
end 

p paths.max

# 2

p paths.select {|a| a >= 1000}.length


