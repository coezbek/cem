#
# https://adventofcode.com/2018/day/21 part 1 and part 2 
#
# Does not use any 'cem' functions
#
# Why this took long: Did not understand the question. 
#
require 'set'

lines = File.readlines("inputs/day21_input.txt", chomp: true)

commandQueue = []

reg = [0,0,0,0,0,0]

ip = nil
lines.each { |line|

  if line =~ /^#ip ([+-]?\d+)$/
    ip = $1.to_i
  end    

  if line =~ /^(\w+) ([+-]?\d+) ([+-]?\d+) ([+-]?\d+)$/
    verb = $1
    v1 = $2.to_i
    v2 = $3.to_i
    v3 = $4.to_i
    
    commandQueue << [verb, v1, v2, v3]
  end
}

commandQueue.each { |x|
  puts x.inspect
} if false

ipp = 0
iteration = 0

s = Set.new
last = nil

while ipp >= 0 && ipp < commandQueue.size

  reg[ip] = ipp
  command = commandQueue[ipp]
  
  puts iteration.to_s.rjust(13) + " " + command.inspect.ljust(40) + " " + reg.inspect if iteration % (1024*1024) == 0
  iteration += 1                                  
  
  case command[0]
        
    when "addr"
    #     addr (add register) stores into register C the result of adding register A and register B.
      reg[command[3]] = reg[command[1]] + reg[command[2]]
    
    when "addi"
    #   addi (add immediate) stores into register C the result of adding register A and value B.
      reg[command[3]] = reg[command[1]] + command[2]
    
    when "mulr"
        # mulr (multiply register) stores into register C the result of multiplying register A and register B.
      reg[command[3]] = reg[command[1]] * reg[command[2]]
    
    when "muli"
       #  muli (multiply immediate) stores into register C the result of multiplying register A and value B.
      reg[command[3]] = reg[command[1]] * command[2]
    
    when "banr"
       #  banr (bitwise AND register) stores into register C the result of the bitwise AND of register A and register B.
      reg[command[3]] = reg[command[1]] & reg[command[2]]
    
    when "bani"
       # bani (bitwise AND immediate) stores into register C the result of the bitwise AND of register A and value B.
      reg[command[3]] = reg[command[1]] & command[2]
    
    when "borr"
        # borr (bitwise OR register) stores into register C the result of the bitwise OR of register A and register B.
      reg[command[3]] = reg[command[1]] | reg[command[2]]
    
    when "bori"
        # bori (bitwise OR immediate) stores into register C the result of the bitwise OR of register A and value B.
      reg[command[3]] = reg[command[1]] | command[2]
    
    when "setr"
        # setr (set register) copies the contents of register A into register C. (Input B is ignored.)
      reg[command[3]] = reg[command[1]] 
    
    when "seti"
        # seti (set immediate) stores value A into register C. (Input B is ignored.)
      reg[command[3]] = command[1]
     
    when "gtir"
        # gtir (greater-than immediate/register) sets register C to 1 if value A is greater than register B. Otherwise, register C is set to 0.
      reg[command[3]] = command[1] > reg[command[2]] ? 1 : 0
    
    when "gtri"
        # gtri (greater-than register/immediate) sets register C to 1 if register A is greater than value B. Otherwise, register C is set to 0.
      reg[command[3]] = reg[command[1]] > command[2] ? 1 : 0
      
      if command[1] == 0
        puts command[2]
        raise
      end
    
    when "gtrr"
        # gtrr (greater-than register/register) sets register C to 1 if register A is greater than register B. Otherwise, register C is set to 0.
      reg[command[3]] = reg[command[1]] > reg[command[2]] ? 1 : 0
      
      if command[1] == 0
        puts reg[command[2]]
        raise
      end
     
    when "eqir"
        # eqir (equal immediate/register) sets register C to 1 if value A is equal to register B. Otherwise, register C is set to 0.
      reg[command[3]] = command[1] == reg[command[2]] ? 1 : 0
          
    when "eqri"
        # eqri (equal register/immediate) sets register C to 1 if register A is equal to value B. Otherwise, register C is set to 0.
      reg[command[3]] = reg[command[1]] == command[2] ? 1 : 0
           
    
    when "eqrr"
        # eqrr (equal register/register) sets register C to 1 if register A is equal to register B. Otherwise, register C is set to 0.
      reg[command[3]] = reg[command[1]] == reg[command[2]] ? 1 : 0 
      
      if command[2] == 0
        if s.size == 0
          puts "Part 1: #{reg[command[1]]}"
        end
        
        puts "#{s.size.to_s.rjust(10)} - #{reg[command[1]]}" if s.size % 64 == 0
        
        if s.include?(reg[command[1]])
          puts "Part 2: #{last}"
          exit
        end
        s.add reg[command[1]]
        last = reg[command[1]]
      end
    
    else
      puts "error" #  raise "Error"
    
  end
  
  if reg[0] != 0
    puts reg[0]
    exit
  end

  ipp = reg[ip]
  ipp += 1
end    

puts reg.inspect
puts reg[0]
