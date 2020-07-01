
#
# https://adventofcode.com/2018/day/5 Part 2
#
# Does not use any cem functions \o/ but did you know:
#
#  - String#swapcase turns a Hello into hELLO?
#  - Regex support 'i' for insensitive matches?
# 

File.readlines("inputs/day5_input.txt").each { |line|

  puts [*'a'..'z'].map { |delete|
            
    out = []
    
    line.gsub(/#{delete}/i, '').each_char { |c|    
      if out.empty? || out.last != c.swapcase
        out << c
      else
        out.pop
      end
    }
    
    out.join.size
  }.min
}


