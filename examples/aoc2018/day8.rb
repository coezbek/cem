#
# https://adventofcode.com/2018/day/8 part 1
#
# Does not use any cem functions \o/ 
# 

input = File.read("inputs/day8_input.txt").split

stack = []
index = 0
sum = 0

while index < input.size

  n_children = input[index].to_i
  index += 1
  n_metaData = input[index].to_i
  index += 1
  
  # f.subpane("out").replace "#{n_children}, #{n_metaData}"
  
  stack << [n_children, n_metaData]
  
  while stack.size > 0 && stack.last.first == 0
    stack.last.last.times { 
      sum += input[index].to_i
      index += 1
    }
    
    stack.pop
  end
  
  if stack.size > 0
    stack.last[0] -= 1
  end
  
end

puts sum
