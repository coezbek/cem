
#
# https://adventofcode.com/2018/day/17 part 1 and 2
#
# Demonstrates Point2D and Dir2D in particular #left, #right, #down methods. Could use Grid!
#

require 'cem'
require 'set'

input = File.readlines("inputs/day17_input.txt", chomp: true)

@vert = []
@hori = []
@waterTiles = Set.new
@deepWater = Set.new

input.each { |line|

  if line =~ /^y=([+-]?\d+), x=([+-]?\d+)..([+-]?\d+)$/
    v1 = $1.to_i
    v2 = $2.to_i
    v3 = $3.to_i
    
    @vert << [v1,v2,v3]
  end    

  if line =~ /^x=([+-]?\d+), y=([+-]?\d+)..([+-]?\d+)$/
    v1 = $1.to_i
    v2 = $2.to_i
    v3 = $3.to_i
    
    @hori << [v1,v2,v3]
  end    
}

@minY = [@vert.map { |v| v[0] }.min, @hori.map { |h| h[1] }.min].min
@maxY = [@vert.map { |v| v[0] }.max, @hori.map { |h| h[2] }.max].max

@minX = [@hori.map { |v| v[0] }.min, @vert.map { |h| h[1] }.min].min
@maxX = [@hori.map { |v| v[0] }.max, @vert.map { |h| h[2] }.max].max

cursor = Point2D.new(500, @minY)

@map = []
(0..@maxY + 1).each { |y|
  @map << []
  (0..@maxX + 1).each { |x|
    @map[y] << ' '
  }
}

@vert.each { |v|
  (v[1]..v[2]).each {|x| @map[v[0]][x] = 'x' }
}
@hori.each {|h|
  (h[1]..h[2]).each {|y| @map[y][h[0]] = 'x' }
}

def free(cursor)
  @map[cursor.y][cursor.x] == ' '
end

def printMap(filename, map, overlay, deepWater, cursor=nil, windowSizeY = 15, windowSizeX = 35)

  file = File.open(filename, 'w') if filename

  if !filename
    system('cls')
    puts cursor
  end
  
  rangeY = cursor ? ((cursor.y - windowSizeY)..(cursor.y + windowSizeY)) : 0...map.size
  rangeX = cursor ? ((cursor.x - windowSizeX)..(cursor.x + windowSizeX)) : 0...map[0].size
  
  rangeY.each { |y|
    l = map[y]
    line = ''
    rangeX.each { |x|
      if l != nil
        c = l[x]
      else
        c = nil
      end
          
      if c == nil
        c = '?'
      end
          
      pos = Point2D.new(x,y)
      if deepWater && deepWater.include?(pos)
        line += '~'
      elsif overlay && overlay.include?(pos)
        line += '|'
      else
        line += c
      end
    } 
    if filename 
      file.write(line + "\n")
    else
      puts line
    end
  } 
  
  if !filename
    gets
  else
    file.close
  end
  
end

# 
# returns true if all available space has been filled
#
def cursorMove(cursor)

  cursorStart = cursor

  @waterTiles << cursor

  # Traverse down from cursor position
  while free(cursor.down) && cursor.y < @maxY && !@waterTiles.include?(cursor.down)    
    printMap(nil, @map, @waterTiles, @deepWater, cursor) if false 
    
    cursor = cursor.down
    @waterTiles << cursor
  end
  
  if cursor.y == @maxY 
    return false # we moved out of the field - stop recursion
  end
  
  if @waterTiles.include?(cursor.down) && !@deepWater.include?(cursor.down)
    return false # already been here
  end  
  
  # Below us is rock
  left = right = rowStart = cursor
  
  row = Set.new
  row << rowStart
  
  while true 
    
    while free(left.left) && !@waterTiles.include?(left.left) && (!free(left.down) || @deepWater.include?(left.down))
      left = left.left
      row << left
      @waterTiles << left
    end
    
    while free(right.right) && !@waterTiles.include?(right.right) && (!free(right.down) || @deepWater.include?(right.down))
      right = right.right
      row << right
      @waterTiles << right
    end
  
    printMap(nil, @map, @waterTiles, @deepWater, cursor) if false # && cursor.y > 1300 && cursor.y < 1330
  
    if !free(right.right) && (!free(right.down) || @deepWater.include?(right.down)) && !free(left.left) && (!free(left.down) || @deepWater.include?(left.down))
      
      # Move up                  
      rowStart = rowStart.up
      
      @deepWater.merge row
      row = Set.new
      row << rowStart
      
      if rowStart.y < cursorStart.y
        return true # Return true, if we filled all available space
      end
      
      left = right = rowStart

      # Fill again...
      
    else
    
      a = !@waterTiles.include?(right.right) && !@waterTiles.include?(left.left)
      if free(right.down) && !(!free(right.down) || @deepWater.include?(right.down))
        a &= cursorMove(right.down)
      end
      
      if free(left.left) && !(!free(left.down) || @deepWater.include?(left.down))
        a &= cursorMove(left.down)
      end
      
      if !a 
        break
      end
    end
  end
  
  return false
end

cursorMove(cursor)

printMap("day17.out", @map, @waterTiles, @deepWater) if false

puts "Part 1: #{@waterTiles.size}"
puts "Part 2: #{@deepWater.size}"
