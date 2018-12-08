A = "137, 282
229, 214
289, 292
249, 305
90, 289
259, 316
134, 103
96, 219
92, 308
269, 59
141, 132
71, 200
337, 350
40, 256
236, 105
314, 219
295, 332
114, 217
43, 202
160, 164
245, 303
339, 277
310, 316
164, 44
196, 335
228, 345
41, 49
84, 298
43, 51
158, 347
121, 51
176, 187
213, 120
174, 133
259, 263
210, 205
303, 233
265, 98
359, 332
186, 340
132, 99
174, 153
206, 142
341, 162
180, 166
152, 249
221, 118
95, 227
152, 186
72, 330"
require 'set'
coordinates = A.split("\n").map {|x| x.split(",")}.map {|a,b| [a.to_i, b.to_i]}

hash = {}
coordinates.each_with_index do |(x,y),i|
  hash[[y,x]] = i
end

infinites = Set.new
counts = Hash.new(0)
for j in 0..400
  for i in 0..400
    distance = {}
    hash.each do |k,v|
      y, x = k
      distance[v] = (y-j).abs + (x-i).abs
    end
    mins = distance.sort_by {|k,v| v}[0..1]
    if mins.first.last != mins.last.last
      min = mins.first
      if i == 0 || i == 400 || j == 0 || j == 400
        infinites << min[0]
      end  
      counts[min[0]] += 1
    end  
  end
end

p counts.reject {|k,v| infinites.include?(k)}.sort_by {|k,v| -v}.first.last

region = 0
for j in 0..400
  for i in 0..400
    distance = 0
    hash.each do |k,v|
      y, x = k
      sub_distance = (y-j).abs + (x-i).abs
      distance += sub_distance
    end
    if distance < 10000
      region += 1
    end
  end
end

p region      

