A = File.read("aoc_2018_4.txt")

# 1

logs = {}
starting_minute = nil
security_id = nil
a = A.split("\n").sort.map {|b| b.split("]")}
a.each do |timestamp, description|
  date, time = timestamp.split(" ")
  minute = time.sub("]","").split(":")[1].to_i

  id = description.split(" ").detect {|t| t.include?("#")} || security_id
  if id
    security_id = id
  end
  if description.include? "falls asleep"
    starting_minute = minute
  elsif description.include? "wakes up"
    logs[id] ||= []
    logs[id] += (starting_minute..minute-1).to_a
  end    
end

id = logs.sort_by {|k,v| -v.length}.first.first[1..-1].to_i

minutes = logs["##{id}"]
counts = Hash.new(0)
minutes.each { |m| counts[m] += 1 }

minute = counts.sort_by {|k,v| -v}.first.first

p id*minute

# 2

max_count = 0
max_minute = 0
max_id = 0
logs.each do |id, minutes|
  counts = Hash.new(0)
  minutes.each { |m| counts[m] += 1 }
  max_subcount = counts.sort_by {|k,v| -v}.first.last
  if max_subcount > max_count
    max_count = max_subcount
    max_minute = counts.sort_by {|k,v| -v}.first.first
    max_id = id[1..-1].to_i
  end
end

p max_id*max_minute  

