require 'set'

A = File.read('aoc_2018_25.txt')

def m_distance(a,b,c,d,e,f,g,h)
  (a-e).abs+(b-f).abs+(c-g).abs+(d-h).abs
end

arr = A.split("\n").map {|a| a.split(",").map(&:to_i)}
constellations = []

until arr.length == 0
  a,b,c,d = arr.first

  init_const = arr.select {|e,f,g,h| m_distance(a,b,c,d,e,f,g,h) <= 3}
  const_set = init_const.to_set

  loop do
    init_const.each do |a,b,c,d|
      arr.select {|e,f,g,h| m_distance(a,b,c,d,e,f,g,h) <= 3}.each do |a|
        const_set << a
      end
    end
    break if const_set.length == init_const.length
    init_const = const_set.clone
  end
  constellations << init_const
  arr.reject! {|a| init_const.include?(a)}
end

puts constellations.length






