
#
# https://adventofcode.com/2018/day/6 Part 1 and 2
#
# Uses Point2D from cem

require 'cem'

out = {}
points = []
largestRegion = 0

File.readlines("inputs/day6_input.txt", chomp: true).each { |line|
  if line =~ /^(\d+), (\d+)$/
    v1 = $1.to_i
    v2 = $2.to_i
    
    points << Point2D.new(v1, v2)
  end
}

minX, maxX = points.map { |p| p.x }.minmax
minY, maxY = points.map { |p| p.y }.minmax

(minX..maxX).each { |x|
  (minY..maxY).each { |y|
  
    coord = Point2D.new(x,y)
  
    nearest = points.group_by { |p| p.manhattan(coord) }.min_by { |k,v| k } 
        
    # puts nearest.inspect
    if nearest.last.size == 1
      (out[nearest.last.first] ||= []) << coord
    end
    
    if points.sum { |p| p.manhattan(coord) } < 10000
      largestRegion += 1
    end
  }
}

puts "Part 1"
puts out.max_by { |k,v|
  if v.select { |coord| (coord.x == maxX || coord.x == minX || coord.y == maxY || coord.y == minY) }.empty?
    v.size
  else
    0 # don't care about infinite
  end
}.last.size

puts "Part 2"
puts largestRegion 
