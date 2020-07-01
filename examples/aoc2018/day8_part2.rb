#
# https://adventofcode.com/2018/day/8 part 2
#
# Does not use any cem functions \o/ 
# 

input = File.read("inputs/day8_input.txt").split

stack = []
index = 0

while index < input.size

  n_children = input[index].to_i
  index += 1
  n_metaData = input[index].to_i
  index += 1
  
  if n_children == 0
  
    metadata = 0
    n_metaData.times { 
      metadata += input[index].to_i
      index += 1
    }
  
    stack.last[2] << metadata
    stack.last[0] -= 1
    
    while stack.last.first == 0
  
      metadata = 0
      stack.last[1].times { 
        selector = input[index].to_i - 1
        index += 1
        
        if selector < stack.last[2].size
          metadata += stack.last[2][selector]
        end        
      }
      
      stack.pop
      
      if stack.size > 0
        stack.last.last << metadata
      else
        puts metadata
        exit
      end
      
    end    
  
  else
  
    if stack.size > 0
      stack.last[0] -= 1
    end
    stack << [n_children, n_metaData, []]
    
    # puts stack.inspect
  
  end    
end
    
puts stack.inspect
