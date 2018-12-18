def number_of_registers(before, instructions, after)
  count = []
  opcode, a, b, c = instructions
  ra, rb, rc = before[a], before[b], before[c]

  if (after[c] == 1 && a > rb) || (after[c] == 0 && a <= rb)
    count << "gtir"
  end
  
  if (after[c] == 1 && ra > b) || (after[c] == 0 && ra <= b)
    count << "gtri"
  end

  if (after[c] == 1 && ra > rb) || (after[c] == 0 && ra <= rb)
    count << "gtrr"
  end

  if (after[c] == 1 && a == rb) || (after[c] == 0 && a != rb)
    count << "eqir"
  end
  
  if (after[c] == 1 && ra == b) || (after[c] == 0 && ra != b)
    count << "eqri"
  end

  if (after[c] == 1 && ra == rb) || (after[c] == 0 && ra != rb)
    count << "eqrr"
  end   

  if after[c] == ra + b
    count << "addi"
  end
  
  if after[c] == ra + rb
    count << "addr"
  end
  
  if after[c] == ra*rb
    count << "mulr"
  end
  
  if after[c] == ra*b
    count << "muli"
  end
  
  if after[c] == ra & rb
    count << "banr"
  end
  
  if after[c] == ra & b
    count << "bani"
  end
  
  if after[c] == ra | rb
    count << "borr"
  end
  
  if after[c] == ra | b
    count << "bori"
  end

  if after[c] == ra
    count << "setr"
  end
  
  if after[c] == a
    count << "seti"
  end    
  
  [opcode, count]
end

def add_to_register(opcode, a, b, c, register)
  ra, rb, rc = register[a], register[b], register[c]

  if @opcode[opcode] == "gtir"
    register[c] = 1 if a > rb 
    register[c] = 0 if a <= rb
  end
  
  if @opcode[opcode] == "gtri"
    register[c] = 1 if ra > b 
    register[c] = 0 if ra <= b
  end


  if @opcode[opcode] == "gtrr"
    register[c] = 1 if ra > rb 
    register[c] = 0 if ra <= rb
  end
  
  if @opcode[opcode] == "eqir"
    register[c] = 1 if a == rb 
    register[c] = 0 if a != rb
  end
  
  if @opcode[opcode] == "eqri"
    register[c] = 1 if ra == b 
    register[c] = 0 if ra != b
  end
  
  if @opcode[opcode] == "eqrr"
    register[c] = 1 if ra == rb 
    register[c] = 0 if ra != rb
  end   
  
  if @opcode[opcode] == "addi"
    register[c] = ra+b
  end
  
  if @opcode[opcode] == "addr"
    register[c] = ra+rb
  end
  
  if @opcode[opcode] == "mulr"
    register[c] = ra*rb
  end
  
  if @opcode[opcode] == "muli"
    register[c] = ra*b
  end
  
  if @opcode[opcode] == "banr"
    register[c] = ra&rb
  end
  
  if @opcode[opcode] == "bani"
    register[c] = ra&b
  end
  
  if @opcode[opcode] == "borr"
    register[c] = ra|rb
  end
  
  if @opcode[opcode] == "bori"
    register[c] = ra|b
  end
  
  if @opcode[opcode] == "setr"
    register[c] = ra
  end
  
  if @opcode[opcode] == "seti"
    register[c] = a
  end  
    
  register
end

# 1

A = File.read('aoc_2018_16_A.txt')
arrs = A.split("\n").reject {|x| x.strip.empty?}.each_slice(3).to_a.map {|a,b,c| [a.sub("Before: ", ""), b.split(" ").join(",").insert(0,"[").insert(-1, "]"), c.sub("After:  ", "")]}
total = 0
arrs.each do |before, instructions, after|
  if number_of_registers(eval(before), eval(instructions), eval(after))[1].length >= 3
    total += 1
  end
end

p total   

# 2

require 'set'
hash = {}
set = Set.new

total = 0
arrs.each do |before, instructions, after|
  opcode, count = number_of_registers(eval(before), eval(instructions), eval(after))
  hash[opcode] ||= Set.new 
  hash[opcode] += count   
end

new_hash = hash.clone
until hash.all? {|k,v| v.length == 1}
  hash.each do |k,v|
    if v.length == 1
      
      (new_hash.keys - [k]).each do |l|
        new_hash[l].delete(v.first)
      end
    end
  end
  hash = new_hash.clone
end

@opcode = {}
hash.each do |k,v|
  @opcode[k] = v.first
end

B = File.read('aoc_2018_16_B.txt')

register = [0,0,0,0]
B.split("\n").map {|a| a.split(" ").map(&:to_i)}.each do |opcode, a, b, c|
  register = add_to_register(opcode, a, b, c, register)
end

p register.first  



