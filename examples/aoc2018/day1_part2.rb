
#
# https://adventofcode.com/2018/day/1 Part 2
#
# Does not use any cem functions \o/ but did you know:
#
#   - Set provides #[] as a class method: Set[1,2,3] is the same as Set.new() and then Set.add(...)
#   - Set provides #add?() to add and check if the object added was already in the Set (returns nil in case).
#
#   For example: Set[0,1].add?(1) => nil
#

require 'set'

cur = 0
seen_before = Set[0]

while true
  File.read("inputs/day1_input.txt").each_line { |line|

    cur += line.to_i
    
    if !seen_before.add?(cur)
      puts cur
      exit
    end
  }
end 
  
# Unreachable!