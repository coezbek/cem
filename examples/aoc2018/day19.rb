#
# https://adventofcode.com/2018/day/19 part 1 and 2
#

# My code was too slow to handle this problem, so this is really more analytical from observing the state of the machine and figuring out what it does.

shortcut = true
if shortcut

  result = 0
  (1..930).each { |i|
    result += i if 930 % i == 0
  }
  puts "Part 1: #{result}"

  result = 0
  (1..10551330).each { |i|
    result += i if 10551330 % i == 0
  }
  puts "Part 2: #{result}"
  exit
end


[1,2].each { |part|

  lines = File.readlines("inputs/day19_input.txt", chomp: true)

  commandQueue = []

  reg = [part - 1, 0, 0, 0, 0, 0]

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

  if false
    puts "Command queue:"
    commandQueue.each { |x|
      puts "  " + x.inspect
    }
  end

  ipp = 0
  i = 0
  reset = true

  while ipp >= 0 && ipp < commandQueue.size

    reg[ip] = ipp
    command = commandQueue[ipp]
    
    puts command.inspect + " " + reg.inspect if i % (256*1024) == 0
    i += 1
    
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
    
    when "gtrr"
        # gtrr (greater-than register/register) sets register C to 1 if register A is greater than register B. Otherwise, register C is set to 0.
      reg[command[3]] = reg[command[1]] > reg[command[2]] ? 1 : 0
     
    when "eqir"
        # eqir (equal immediate/register) sets register C to 1 if value A is equal to register B. Otherwise, register C is set to 0.
      reg[command[3]] = command[1] == reg[command[2]] ? 1 : 0
    
    when "eqri"
        # eqri (equal register/immediate) sets register C to 1 if register A is equal to value B. Otherwise, register C is set to 0.
      reg[command[3]] = reg[command[1]] == command[2] ? 1 : 0
    
    when "eqrr"
        # eqrr (equal register/register) sets register C to 1 if register A is equal to register B. Otherwise, register C is set to 0.
      reg[command[3]] = reg[command[1]] == reg[command[2]] ? 1 : 0 
    
    else
      raise "Error"      
    end

    ipp = reg[ip]
    ipp += 1
  end    

  puts reg.inspect
  puts "Part#{part}: #{reg[0]}"
}
