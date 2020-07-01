
#
# https://adventofcode.com/2018/day/9 part 1 and part 2
#
# Does not use any cem functions \o/, but did you know that 
#  - Array#shift is supposed to be fast, but is not fast enough for this problem?
# 

players = 428 
marbles = 70825

def day9(players, marbles)

  scores = [0] * players

  nexta = 3
  storage = [0, 2, 1] 
  current = 1
  front = 0

  while nexta < marbles 

    if nexta % 23 == 0
      
      current = (current + storage.size - 7) % storage.size
      worth = nexta + storage.delete_at(current)
      scores[nexta % players] += worth
    
    else
    
      # Avoid wrapping the index
      while current + 2 > storage.size
        front_value = storage[front]
        front += 1
        storage.push front_value  
      end
      
      current += 2
      storage.insert(current, nexta)
      
    end
    
    nexta += 1
    
  end
  
  return scores.max
end  
  
puts "One Star : #{day9(players, marbles)}"
puts "Two Stars: #{day9(players, marbles * 100)}"