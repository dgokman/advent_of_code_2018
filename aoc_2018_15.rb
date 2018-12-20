require 'set'

A = "################################
#########....#..#####.......####
###########G......###..##..#####
###########.....#.###......#####
###############.#...#.......####
###############..#....E......###
############.##...#...G....#####
############.##.....G..E...#####
###########G.##...GG......######
#..####G##..G##..G.#......######
#..........#............#.######
#.......#....G.......G.##..#...#
#.....G.......#####...####...#.#
#.....G..#...#######..#####...E#
#.##.....G..#########.#######..#
#........G..#########.#######E##
####........#########.##########
##.#........#########.##########
##.G....G...#########.##########
##...........#######..##########
#.G..#........#####...##########
#......#.G.G..........##########
###.#................###########
###..................###.#######
####............E.....#....#####
####.####.......####....E.######
####..#####.....####......######
#############..#####......######
#####################EE..E######
#####################..#.E######
#####################.##########
################################"

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

def field_value(i, j, field)
  if field[i][j] != "."
    Float::INFINITY
  else
    1
  end
end      


def create_graph(field)
  arrs = Marshal.load(Marshal.dump(field))
  i, j = 0,0
  while i < arrs.length
    while j < arrs[i].length
      arrs[i][j] = field_value(i, j, field)
      j += 1
    end
    i += 1
    j = 0
  end
       
  graph = []
  i, j = 0,0
  while i < arrs.length
    while j < arrs[i].length
      if j == 0 && i == 0
        graph << ["#{i}-#{j}", "#{i}-#{j+1}",arrs[i][j+1]]
        graph << ["#{i}-#{j}", "#{i+1}-#{j}",arrs[i+1][j]]
      elsif i == 0 && j < arrs[i].length-1
        graph << ["#{i}-#{j}", "#{i+1}-#{j}",arrs[i+1][j]]
        graph << ["#{i}-#{j}", "#{i}-#{j+1}",arrs[i][j+1]]
        graph << ["#{i}-#{j}", "#{i}-#{j-1}",arrs[i][j-1]]
      elsif i == 0 && j == arrs.length-1
        graph << ["#{i}-#{j}", "#{i+1}-#{j}",arrs[i+1][j]]
        graph << ["#{i}-#{j}", "#{i}-#{j-1}",arrs[i][j-1]]
      elsif j == 0 && i < arrs.length-1
        graph << ["#{i}-#{j}", "#{i}-#{j+1}",arrs[i][j+1]]
        graph << ["#{i}-#{j}", "#{i+1}-#{j}",arrs[i+1][j]]
        graph << ["#{i}-#{j}", "#{i-1}-#{j}",arrs[i-1][j]]
      elsif j == 0 && i == arrs.length-1
        graph << ["#{i}-#{j}", "#{i}-#{j+1}",arrs[i][j+1]]
        graph << ["#{i}-#{j}", "#{i-1}-#{j}",arrs[i-1][j]]
      elsif i == arrs.length-1 && j > 0
        graph << ["#{i}-#{j}", "#{i}-#{j+1}",arrs[i][j+1]]
        graph << ["#{i}-#{j}", "#{i}-#{j-1}",arrs[i][j-1]]
        graph << ["#{i}-#{j}", "#{i-1}-#{j}",arrs[i-1][j]]
      elsif j == arrs[i].length-1 && i > 0
        graph << ["#{i}-#{j}", "#{i+1}-#{j}",arrs[i+1][j]]
        graph << ["#{i}-#{j}", "#{i}-#{j-1}",arrs[i][j-1]]
        graph << ["#{i}-#{j}", "#{i-1}-#{j}",arrs[i-1][j]]
      else
        graph << ["#{i}-#{j}", "#{i+1}-#{j}",arrs[i+1][j]]
        graph << ["#{i}-#{j}", "#{i-1}-#{j}",arrs[i-1][j]]
        graph << ["#{i}-#{j}", "#{i}-#{j+1}",arrs[i][j+1]]
        graph << ["#{i}-#{j}", "#{i}-#{j-1}",arrs[i][j-1]]
      end
      j += 1
    end
    i += 1
    j = 0
  end

  graph
end 

def shortest_path(graph, init_y, init_x, end_y, end_x, field)
  
  shortest_paths = []
  
  first_step = [init_y-1, init_x]
  second_step = [init_y, init_x-1]
  third_step = [init_y, init_x+1]
  fourth_step = [init_y+1, init_x]

  g = Graph.new(graph)  
  if field[first_step[0]][first_step[1]] == "." 
    first_g = g.shortest_path("#{first_step[0]}-#{first_step[1]}", "#{end_y}-#{end_x}") 
  end
  if field[second_step[0]][second_step[1]] == "."
    second_g = g.shortest_path("#{second_step[0]}-#{second_step[1]}", "#{end_y}-#{end_x}") 
  end
  if field[third_step[0]][third_step[1]] == "."
    third_g = g.shortest_path("#{third_step[0]}-#{third_step[1]}", "#{end_y}-#{end_x}") 
  end
  if field[fourth_step[0]][fourth_step[1]] == "."
    fourth_g = g.shortest_path("#{fourth_step[0]}-#{fourth_step[1]}", "#{end_y}-#{end_x}") 
  end
  
  paths = [first_g, second_g, third_g, fourth_g]
  distance1 = first_g ? first_g[1] : Float::INFINITY
  distance2 = second_g ? second_g[1] : Float::INFINITY
  distance3 = third_g ? third_g[1] : Float::INFINITY
  distance4 = fourth_g ? fourth_g[1] : Float::INFINITY
  min = [distance1, distance2, distance3, distance4].min
  distances = [[0,distance1], [1,distance2], [2,distance3], [3,distance4]]
  valid_distances = distances.select {|i,d| d == min}


  if !valid_distances.any? || valid_distances.all? {|x| x[1] >= 10**9}
    return nil
  else
    steps = paths[valid_distances.first.first][0]
    return steps.map {|a| a.split("-").map(&:to_i)} 
  end  
  
end  

def all_positions(letter, field)
  arr = []
  for y in 0..field.length-1
    for x in 0..field[y].length-1
      if field[y][x] == letter
        arr << [y,x]
      end
    end
  end
  arr
end

def enemy_to_attack(enemies)
  enemies.sort.sort_by {|y,x| @hit_points[[y,x]]}.first
end     

def move(y, x, field, second_move=false)

  hero = field[y][x]
  enemy_positions = hero == "G" ? all_positions("E", field) : all_positions("G", field)
  in_range = []
  enemies = []
  enemy_positions.each do |yy, xx|
    if (yy+1 == y && xx == x) || (yy-1 == y && xx == x) || (yy == y && xx-1 == x) || (yy == y && xx+1 == x)
      enemies << [yy, xx]
    else  
      in_range += [[yy-1,xx], [yy+1,xx], [yy,xx-1], [yy,xx+1]].select {|yyy,xxx| field[yyy][xxx] == "."}
    end  
  end
  if enemies.any?
    return enemy_to_attack(enemies) << "attack"
  end
  return if second_move  

  nearest = []
  in_range.each do |end_y,end_x|
    nearest << [end_y, end_x, (y-end_y).abs+(x-end_x).abs]
  end 
  
  correct_shortest_path = []
  lengths = []
  graph = create_graph(field)
  nearest.uniq.sort_by {|a,b,c| c}.map {|a,b,_| [a,b]}.each do |end_y,end_x|

    if !@visited.include?([y,x,end_y,end_x,field])
      shortest_path = shortest_path(graph,y,x,end_y,end_x, field)

      if shortest_path
        correct_shortest_path << shortest_path
        lengths << shortest_path.length
      end
        
      @visited << [y,x,end_y,end_x,field]
      if correct_shortest_path.length == 6
        break
      end
    end  
  end
  
  return [y,x] unless correct_shortest_path.any?
  selected_correct_shortest_path = correct_shortest_path.select {|a| a.length == lengths.min }.sort.first

  selected_correct_shortest_path[0]
end

[A].each do |cons|
  initial_field = cons.split("\n").map {|x| x.split("")}
  field = Marshal.load(Marshal.dump(initial_field))

  @hit_points = Hash.new(200)
  @count = 0
  @visited = Set.new
  loop do
    moved = Set.new
   
    for y in 0..field.length-1
      for x in 0..field[y].length-1

        if (field[y][x] == "G" || field[y][x] == "E") && !moved.include?([y,x])
          move = move(y,x,field)
          if move.last == "attack"
            enemy_y, enemy_x = move[0], move[1]
            @hit_points[[enemy_y,enemy_x]] -= 3
            if @hit_points[[enemy_y,enemy_x]] <= 0
              field[enemy_y][enemy_x] = "."
              @hit_points.delete([enemy_y,enemy_x])
            end  
          else  
            new_y, new_x = move
            if new_y != y || new_x != x
              letter = field[y][x]
              field[y][x] = "."
              field[new_y][new_x] = letter

              new_move = move(new_y,new_x,field,true)
              if new_move && new_move.last == "attack"
                
                enemy_y, enemy_x = new_move[0], new_move[1]
                @hit_points[[enemy_y,enemy_x]] -= 3
                if @hit_points[[enemy_y,enemy_x]] <= 0
                  field[enemy_y][enemy_x] = "."
                  @hit_points.delete([enemy_y,enemy_x])
                end
              end  

              moved << [new_y,new_x]
            end  
            @hit_points[[new_y,new_x]] = @hit_points[[y,x]]
            @hit_points.delete([y,x]) unless new_y == y && new_x == x
          end  
        end
      end
    end

    if field.flatten.count("E") == 0 || field.flatten.count("G") == 0
      puts @count*@hit_points.values.inject(:+)
      break
    end
   
    @count += 1   
  end
end      



