#
# https://adventofcode.com/2018/day/20 part 1 and 2
#
# Took 1:10 min for both parts (not bad!)
#
# Could have been faster, but ruzzles parts had to be created for this:
#
#  - Grid.minmax
#  - Point2D.from_s
#  - Point2D.to_dir_bitmask / from_dir_bitmask
#  - Dirs2D
#

require 'cem'

line = File.read("inputs/day20_input.txt")

stack = [[Point2D.new(500,500)]]

grid = Grid.new(1000, 1000, 0)

line.chars.each { |c|
  case c

    when '$'   
      # ignore
    when '^'  
      # ignore  
    when "\n"
      # ignore    
    
    when '(' 
      newCurCursor = stack.last.map { |p| p.dup }
      stack << []           # One below top() are all cursors we collected as part of this opening brace group
      stack << newCurCursor # Stack.top() is all current cursor position we are tracking

    when ')'      
      lastGroup = stack.pop
      otherGroupsInBrace = stack.pop
      replacedGroup = stack.pop
      stack << (lastGroup + otherGroupsInBrace).uniq
    
    when 'E', 'N', 'S', 'W'      
      dir = Point2D.from_s(c)
      
      stack.last.map! { |p|
        grid[p] |= dir.to_dir_bitmask
        p += dir
        grid[p] |= dir.flip.to_dir_bitmask
        p
      }
    when '|'   
      lastGroup = stack.pop
      stack.last.concat lastGroup
      stack << stack[-2].map { |p| p.dup }
      
  else
    raise "Unknown char '#{c.inspect}'"
  end
}

if false # Print Grid for debugging

  min, max = grid.minmax(0)  
  count = 0
  
  (min.y..max.y).each {|y|
    a = ""
    b = ""
    (min.x..max.x).each { |x|
      count += 1 if grid[y,x] > 0
      a += "#" + (grid[y,x] & 1 == 1 ? "|" : "#") 
      b += (grid[y,x] & 8 == 8 ? "-" : "#") + (grid[y,x] > 0 ? "." : "#")
    }
    puts a + "#"
    puts b + "#"
  }
  
end

# Run BFS search
q = [[Point2D.new(500,500), 0]]

maxSteps = 0
rooms = 0
while q.size > 0
  p, maxSteps = q.shift
  
  if maxSteps >= 1000
    rooms += 1
  end
    
  Point2D.from_dir_bitmask(grid[p]).each { |dir|
    grid[p+dir] &= ~dir.flip.to_dir_bitmask # Close door we walked through. Due to BFS, we never have to get to it again
    
    q << [p+dir, maxSteps+1]    
  }
  grid[p] = 0

end

puts "Part 1: #{maxSteps}"
puts "Part 2: #{rooms}"
