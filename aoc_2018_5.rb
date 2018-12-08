A = File.read("aoc_2018_5.txt")

# 1

def scan_polymer(letter=nil)
  length = 0
  b = letter ? A.gsub(letter, "").gsub(letter.capitalize, "") : A
  c = nil
  loop do
    c = b.clone
    b.split("").each_cons(2).each do |aa,bb|
      if aa != bb && (aa.capitalize == bb || bb.capitalize == aa) && (index = c.index("#{aa}#{bb}"))
        c[index] = ""
        c[index] = ""
      end
    end
    if c.length == length
      return length
    end  
    length = c.length
    b = c.clone
  end      
end

p scan_polymer

# 2

min = Float::INFINITY

("a".."z").to_a.each do |l|
  length = scan_polymer(l)      
  
  if length < min
    min = length
  end
end

p min  