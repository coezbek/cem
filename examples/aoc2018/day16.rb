#
# https://adventofcode.com/2018/day/16 part 1 and part 2 
#
# Does not use any 'cem' functions
#

input = File.readlines("inputs/day16_input.txt", chomp: true)

data = []
inputs = []

input.each { |line|

  if line =~ /^Before\: \[([+-]?\d+), ([+-]?\d+), ([+-]?\d+), ([+-]?\d+)\]$/
    
    v1 = $1.to_i
    v2 = $2.to_i
    v3 = $3.to_i
    v4 = $4.to_i
    
    data << [v1,v2,v3,v4]
    
  end    

  if line =~ /^([+-]?\d+) ([+-]?\d+) ([+-]?\d+) ([+-]?\d+)$/
    

    v1 = $1.to_i
    v2 = $2.to_i
    v3 = $3.to_i
    v4 = $4.to_i
    
    data << [v1,v2,v3,v4]    
  end    

  if line =~ /^After\:  \[([+-]?\d+), ([+-]?\d+), ([+-]?\d+), ([+-]?\d+)\]$/
    v1 = $1.to_i
    v2 = $2.to_i
    v3 = $3.to_i
    v4 = $4.to_i
    
    data << [v1,v2,v3,v4]
        
    # puts data.inspect
    inputs << data
    data = []
  end    

  if line =~ /^$/
    # data << $1.to_i
  end  
}

mapping = {}

def op(op, reg, command)

  case op
  
  when 0 # addr
    reg[command[1]] + reg[command[2]]
  
  when 1 # addi
    reg[command[1]] + command[2]
  
  when 2 # mulr
    reg[command[1]] * reg[command[2]]
  
  when 3 #muli
    reg[command[1]] * command[2]
  
  when 4 # banr
    reg[command[1]] & reg[command[2]]
  
  when 5 # bani
    reg[command[1]] & command[2]
  
  when 6 # borr
    reg[command[1]] | reg[command[2]]
  
  when 7 # bori
    reg[command[1]] | command[2]
  
  when 8 # setr
    reg[command[1]] 
  
  when 9 # seti
    command[1]
   
  when 10 # gtir
    command[1] > reg[command[2]] ? 1 : 0
  
  when 11 # gtri
    reg[command[1]] > command[2] ? 1 : 0
  
  when 12 # gtrr
    reg[command[1]] > reg[command[2]] ? 1 : 0
   
  when 13 # eqir
    command[1] == reg[command[2]] ? 1 : 0
  
  when 14 # eqri
    reg[command[1]] == command[2] ? 1 : 0
  
  when 15 # eqrr
    reg[command[1]] == reg[command[2]] ? 1 : 0 
  
  else
    raise 
  end
end

result = 0
inputs.each { |data|

    # puts data.inspect

    # puts "Before: " + data[0].inspect
    # puts "OP    : " + data[1].inspect
    # puts "After : " + data[2].inspect
    
    # puts data[1].inspect + ": Cmd #{data[1][0]} on reg#{data[1][1]} val=#{data[0][data[1][1]]} op? reg#{data[1][2]} val=#{data[0][data[1][2]]} (imm #{data[1][2]}) == #{data[2][data[1][3]]} (was #{data[0][data[1][3]]})"
    
    command = data[1]
    matches = []
    (0..15).each { |i|
    
      reg = data[0].dup
      
      reg[command[3]] = op(i, reg, command)
      
      if reg == data[2]
        matches << i
      end
    }
    
    result += 1 if matches.size >= 3
    
    matches = matches.select { |m| !mapping.values.include?(m) } 
    
    if matches.size == 1
      mapping[data[1][0]] = matches[0]
    end
    
    # puts matches.inspect
}

# puts mapping.inspect

puts "Part 1: #{result}"

reg = [0,0,0,0]

data.each { |command|
  reg[command[3]] = op(mapping[command[0]], reg, command)
}

puts "Part 2: #{reg[0]}"
