
#
# https://adventofcode.com/2018/day/10 part 1 and part 2
#
# Demonstrates use of 
#  - Point2D#area returns x*y as if the given point was a representing a rectangle starting at 0,0
#  - Point2D#+ and #- allow to use normal vector math on points
#  - Grid.from_points allows to build a Grid view of a set of points
#
# Also did you know that:
#   - Numeric#step can receive a block directly to implement an infinite for loop?
#   - Array#minmax => Find min and max from an array 
#

require 'cem'

input = File.readlines("inputs/day10_input.txt", chomp: true)

data = []

input.each { |line|

  if line =~ /^position=<\s*(-?\d+),\s*(-?\d+)> velocity=<\s*(-?\d+),\s*(-?\d+)>$/
    p1 = $1.to_i
    p2 = $2.to_i
    v1 = $3.to_i
    v2 = $4.to_i
    
    data << [Point2D.new(p1,p2), Point2D.new(v1,v2)]
  else 
    raise line
  end
}

lastSize = nil

# Count iterations from 0, because we need to return the iteration number preceeding the last.
0.step { |iter|

  # Apply velocity to all points
  data.map! { |p, v| [p + v, v] }
  
  min, max = data.map { |p, v| p }.minmax 
    
  size = (max - min).area
  
  # Terminate the search when the area of all points starts growing again.
  if lastSize && size > lastSize
    
    # Go back one iteration
    puts "Word:\n" + Grid.from_points(data.map { |p, v| p - v }).to_s
    
    puts "Iterations until word: #{iter}"
    
    return
    
  end
  
  lastSize = size
}

