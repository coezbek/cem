
#
# https://adventofcode.com/2018/day/25 part 1 (there is only 1
#
# Uses Point4D, but not much to see here.
#
require 'cem'

lines = File.readlines("inputs/day25_input.txt")

input = []

lines.each { |line|

  if line =~ /^\s*([+-]?\d+),([+-]?\d+),([+-]?\d+),([+-]?\d+)\s*$/
    v1 = $1.to_i
    v2 = $2.to_i
    v3 = $3.to_i
    v4 = $4.to_i
    input << Point4D.new(v1,v2,v3,v4)
  else
    raise line.inspect
  end
}

constellations = []

input.each { |p|
  if c = constellations.find { |c| c.any? { |p2| p2.manhattan(p) <= 3 } }
    c << p
  else
    constellations << [p]
  end
}

loop do  
  count = constellations.count { |c| c.size > 0 }
  
  constellations.each_with_index { |c,i|
    constellations.each_with_index { |d,j|
      next if j <= i 
      if c.any? { |p| d.any? { |p2| p2.manhattan(p) <= 3 } }
        c.push(*d)
        d.clear
      end
    }
  }
  break if count == constellations.count { |c| c.size > 0 }
end

puts "Part 1: #{constellations.count { |c| c.size > 0 }}"

