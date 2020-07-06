#
# https://adventofcode.com/2018/day/22 part 1 and 2
#
# Demonstrates some use of Grid and Point2D
#
# Why this was hard: Did not read spec precisely!

require 'set'
require 'cem'

EXTRAX = 10
EXTRAY = 10

verbose = false

lines = File.readlines("inputs/day22_input.txt", chomp: true)

depth = nil
target = nil

lines.each { |line|

  if line =~ /^depth: ([+-]?\d+)$/
    depth = $1.to_i
  end    

  if line =~ /^target: ([+-]?\d+),([+-]?\d+)$/
    target = Point2D.new($1.to_i, $2.to_i)
  end    
}

@depth = depth
@target = target

def erode(x)
  return (x + @depth) % 20183
end  

grid = Grid.new(target.x + EXTRAX + 1, target.y + EXTRAY + 1)
grid[0,0] = 0

(1..target.x + EXTRAX).each { |x|
  grid[0,x] = erode(x * 16807) 
}
(1..target.y + EXTRAY).each { |y|
  grid[y,0] = erode(y * 48271) 
}
  
(1..target.y + EXTRAY).each { |y|
  (1..target.x + EXTRAX).each { |x|
    if target.x == x && target.y == y
      grid[y,x] = erode(0)
    else
      grid[y,x] = erode(grid[y-1,x] * grid[y,x-1]) 
    end
  }
}

puts "Part 1: #{grid[0..target.y, 0..target.x].flatten.sum { |g| g % 3 }}"

if verbose
  grid[0..target.y, 0..target.x].each { |y|
    y.each { |c|
      case c % 3
        when 0
          print '.'
        when 1
          print '='
        when 2
          print '|'
        end
    }
    puts
  }
end

#
# Part 2
# 

neighter = 0
torch = 1
gear = 2

toolGrid = [0,1,2,4].map { |t| Grid.new(target.x + EXTRAX + 1, target.y + EXTRAY + 1, -1)}

toolGrid[torch][0,0] = 0

define_method :toChar do |p|
  case grid[p] % 3
    when 0
      '.'
    when 1
      '='
    when 2
      '|'
  end
end
  
define_method :supportedTools do |p|
  
  case grid[p] % 3 
    when 0 # rocky
      [gear, torch] 
    when 1 # wet
      [neighter, gear]
    when 2 # narrow
      [neighter, torch]
    else
      raise
  end
end

q = [[Point2D.new(0,0), torch]]
while q.size > 0

  p, tool = q.shift
  
  #puts "#{p.inspect} - #{tool} - #{toolGrid[tool][p]} - #{supportedTools(p)}"

  sTools = supportedTools(p)  
  otherTools = ([0,1,2] - [tool]) & supportedTools(p)

  otherTools.each { |t| 
    raise if t == tool
    raise if !sTools.any? { |t2| t == t2 }
  }
  
  raise if toolGrid[tool][p] == -1
  
  otherTools.each { |other|
    if (toolGrid[other][p] == -1) || toolGrid[tool][p] + 7 < toolGrid[other][p]
      toolGrid[other][p] = toolGrid[tool][p] + 7
      q << [p, other] 
    end
  }
  
  grid.nsew_index(p).each { |p2|
    # puts "#{p2.inspect} is adjacent to #{p} and supports the following tools #{supportedTools(p2)}"
    
    if supportedTools(p2).include?(tool) && (toolGrid[tool][p2] == -1 || toolGrid[tool][p] + 1 < toolGrid[tool][p2])
      toolGrid[tool][p2] = toolGrid[tool][p] + 1
      q << [p2, tool]
    end
  }
  
  q.sort_by! { |n|
    p, tool = n
    toolGrid[tool][p]
  }

end    
   
puts "Part 2: #{[toolGrid[torch][target], toolGrid[gear][target] + 7].min}"

if 0 == 1
  (0..target.y + EXTRAY).each { |y|
    (0..target.x + EXTRAX).each { |x|
    
      case grid[y,x] % 3
        
        when 0
          print '.'
        when 1
          print '='
        when 2
          print '|'
        
      end
      
      print (toolGrid[torch][y,x].to_s + "," + toolGrid[neighter][y,x].to_s + "," +toolGrid[gear][y,x].to_s).rjust(8)
    }
    puts ""
  } if DEBUG
    
  reversePath = [[target, toolGrid[torch][target], torch]]  
  p = target
  curTool = torch
  while !(p.x == 0 && p.y == 0)
    
    moves = grid.nsew_index(p).select { |p2| supportedTools(p2).include?(curTool) }.map { |p2| [p2, toolGrid[curTool][p2], curTool]} + 
    (supportedTools(p) - [curTool]).map { |t| [p, toolGrid[t][p], t, :toolChange] }

    p moves
    bestMove = moves.min_by { |x| x[1] }
    
    reversePath.unshift bestMove
    
    # puts p.inspect
    
    p = bestMove[0]
    curTool = bestMove[2]
  end

  reversePath.each { |x|
    puts "[#{x[0].x}, #{x[0].y}, #{x[2]}]   #{toChar(x[0])}        #{x[1]} #{x.size > 3 ? x[3] : ""}"
  }
end    
    
      
    
    
    









