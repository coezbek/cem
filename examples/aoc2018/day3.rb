
#
# https://adventofcode.com/2018/day/3 part 1 and 2
#
# Demonstrates: Point2D, min(a,b), Array::with_progress
#
# Areas for improvement: Rect intersection

require 'set'
require 'cem'

claims = []
intersections = Set.new
doesIntersect = Set.new

Claim = Struct.new("Claim", :x, :y, :width, :height, :claimId)

File.readlines("inputs/day3_input.txt").with_progress.each { |l|

  if l =~ /^\#(\d+) \@ (\d+),(\d+)\: (\d+)x(\d+)$/

    claim = Claim.new($2.to_i, $3.to_i, $4.to_i, $5.to_i, $1.to_i)
    
    claims.each { |other|
      
      x = claim.x
      y = claim.y
      w = claim.width
      h = claim.height
      
      x2 = other.x
      y2 = other.y
      w2 = other.width
      h2 = other.height
      
      if x2 < x 
        x, x2 = x2, x
        w, w2 = w2, w
      end
      
      if y2 < y
        y, y2 = y2, y
        h, h2 = h2, h
      end
      
      # puts "#{claim} - #{other}"
      
      if x + w >= x2 && y + h >= y2
            
        width = min(x2 + w2, x + w)
        height = min(y2 + h2, y + h)
        
        doesIntersect.add(other)
        doesIntersect.add(claim)
      
        for a in x2...width
          for b in y2...height
            # puts "#{a} #{b}"
            intersections.add(Point2D.new(a,b))
          end
        end        
        
      end
    }
    
    claims << claim
  end  
}

puts "Part 1: #{intersections.size}"
puts "Part 2: #{claims.to_set.subtract(doesIntersect).first.claimId}"
