
#
# https://adventofcode.com/2018/day/5 Part 1
#
# Does not use any cem functions \o/ but did you know:
#
#  - String#swapcase turns "Hello" into "hELLO"?
# 

out = []

File.read("inputs/day5_input.txt").each_char { |c|
  
  if out.empty? || out.last != c.swapcase
    out << c
  else
    out.pop
  end

}

puts out.join.size

