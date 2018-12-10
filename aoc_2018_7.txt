A = File.read("aoc_2018_7.txt")
L = "Z"
alphabet = ("A"..L).to_a

directions = {}

A.split("\n").map {|x| x.split(" ").select {|a| alphabet.include?(a)}}.each do |a,b|
  directions[b] ||= []
  directions[b] << a
end

# 1

str = (alphabet.to_a - directions.keys).sort.first

until str.split("").sort == alphabet
  (alphabet.to_a - str.split("")).each do |letter|
    if directions[letter].nil? || directions[letter].all? {|a| str.include?(a)}
      str += letter
      break
    end
  end
end      

puts str

# 2

chart = []
chart << [0, "F", "X", nil, nil, nil, ""]
chart << [66, "M", "X", "O", nil, nil, "F"]
chart << [84, "M", "C", "O", "D", "U", "FX"]
  
until chart.last.last.split("").sort == alphabet
  chart.each do |_, w1, w2, w3, w4, w5, str|
    (alphabet.to_a - str.split("")).each do |letter|
      if [w1,w2,w3,w4,w5].include?(letter)
        if !chart.last.last.include?(letter)
          letter_arr = chart.select {|a| a.include?(letter)}.first
          worker = letter_arr.index(letter)
          letter_start_time = letter_arr.first
          letter_end_time = letter_start_time + alphabet.index(letter)+61
          new_arr = [letter_end_time, chart.last[1], chart.last[2], chart.last[3], chart.last[4], chart.last[5], chart.last.last+letter]
          new_arr[worker] = nil
          chart << new_arr
        end  
      elsif directions[letter].all? {|a| str.include?(a)} && !chart.last.last.include?(letter)
        str_arr = chart.select {|a| a.include?(str)}.first
        str_arr_idx = chart.index(str_arr)
        new_str = str
        until !directions[letter].all? {|a| new_str.include?(a)}
          str_arr_idx -= 1
          new_str = chart[str_arr_idx].last
        end
        str_arr_idx += 1
        str_arr = chart[str_arr_idx]
        
        worker = str_arr.index(nil)
        chart[str_arr_idx][worker] = letter
        for idx in str_arr_idx+1..chart.length-1
          chart[idx][worker] = letter
        end
        break
      end
    end
  end
end

p chart.last.first 