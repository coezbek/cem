
#
# https://adventofcode.com/2018/day/11 part 1 and part 2
#
# Does not use any cem functions \o/ 
#

input = 5177

levels = [0] * (300 * 300)

(1..300).each { |x|
  (1..300).each { |y|
    
    rackId = ( x) + 10
    powerLevel = rackId * ( y)
    powerLevel += input
    powerLevel *= rackId
    powerLevel /= 100
    powerLevel -= powerLevel / 10 * 10
    powerLevel -= 5
    
    levels[y * 300 + x] = powerLevel
  }
}

max = 0     
(1..300).each { |gridsize|

  local_max = nil
  local = nil
  (1..300-gridsize).each { |x|
    (1..300-gridsize).each { |y|

      sum = 0
      
      (0..gridsize-1).each { |dx|
        (0..gridsize-1).each { |dy|
        
          sum += levels[(dy + y) * 300 + dx + x]
        }
      }
      
      if !local_max || sum > local_max
        local = "#{x}, #{y}, #{gridsize}: #{sum}"
        local_max = sum
      end     
    }
  }
  
  if gridsize == 3
    puts "Part 1 result:"
  end
  
  print local  

  if local_max > max  
    puts "***"
    max = local_max
  else
    puts 
    puts "Previous data is max"
    exit
  end
}
    