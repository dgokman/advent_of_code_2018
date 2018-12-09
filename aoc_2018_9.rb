PLAYERS = 471
MARBLE_LIMIT = 72026

# 1 

marble = 3
arr = [0,2,1]
player = 3
new_current_marble_idx = nil
new_idx = 1
scores = [0]*(PLAYERS+1)

until marble > MARBLE_LIMIT
  if new_current_marble_idx
    current_marble_idx = new_current_marble_idx
    new_current_marble_idx = nil
  else  
    current_marble_idx = new_idx
  end  
  if marble % 23 > 0
    new_idx = current_marble_idx+2 > arr.length ? (current_marble_idx+2-arr.length) : current_marble_idx+2
    arr.insert(new_idx,marble)
  else
    scores[player] += marble
    marble_to_pickup_idx = current_marble_idx-7
    scores[player] += arr[marble_to_pickup_idx]
    arr[marble_to_pickup_idx] = nil
    arr = arr.compact
    new_current_marble_idx = marble_to_pickup_idx >= 0 ? marble_to_pickup_idx : arr.length+marble_to_pickup_idx+1
  end  
      
  marble += 1
  player += 1
  player = player > PLAYERS ? 1 : player
end  

puts scores.max

# 2

# MARBLE_LIMIT = 7202600