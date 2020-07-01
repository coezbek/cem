
#
# https://adventofcode.com/2018/day/2 part 2
#
# Does not use any cem functions \o/

previous = ''
File.readlines("inputs/day2_input.txt").sort.each { |l|

  mismatch = 0
  s = ''
  if previous != ''
    l.split("").each_with_index { |c, i|
      if previous[i] != c 
        mismatch += 1 
      else
        s += c
      end      
    }  
  end
  
  if mismatch == 1
    puts s
  end
  
  previous = l
}
