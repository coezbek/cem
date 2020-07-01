
#
# https://adventofcode.com/2018/day/1 Part 1
#
# Does not use any cem functions \o/
#

result = 0
File.read("inputs/day1_input.txt").each_line { |line|
  result += line.to_i 
}

puts result
