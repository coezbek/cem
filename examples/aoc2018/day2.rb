
#
# https://adventofcode.com/2018/day/2
#
# Does not use any cem functions \o/ 
#
twice = 0
thrice = 0

chars = [*'a'..'z', *'A'..'Z']

File.read("inputs/day2_input.txt").each_line { |l|

  twice += 1 if chars.any? { |c| l.count(c) == 2 }
  thrice += 1 if chars.any? { |c| l.count(c) == 3 }

}

puts "1st star: #{twice * thrice}"

