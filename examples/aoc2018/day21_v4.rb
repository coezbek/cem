#
# https://adventofcode.com/2018/day/21 part 1 and part 2 
#
# Does not use any 'cem' functions
#
# Rev 4: Replace the register array access with local variables => Double speed up. 
#
require 'cem'
require 'set'

lines = File.readlines("inputs/day21_input.txt", chomp: true)

commandQueue = []

r0 = r1 = r2 = r3 = r4 = r5 = 0
@s = Set.new
@last = nil

def command(verb, v1, v2, v3)

  case verb
  when "addr"
  #     addr (add @register) stores into @register C the result of adding @register A and @register B.
    " r#{v3} = r#{v1} + r#{v2} "
  
  when "addi"
  #   addi (add immediate) stores into @register C the result of adding @register A and value B.
    " r#{v3} = r#{v1} + #{v2} "
  
  when "mulr"
      # mulr (multiply @register) stores into @register C the result of multiplying @register A and @register B.
    " r#{v3} = r#{v1} * r#{v2} "
  
  when "muli"
     #  muli (multiply immediate) stores into @register C the result of multiplying @register A and value B.
    " r#{v3} = r#{v1} * #{v2} "
  
  when "banr"
     #  banr (bitwise AND @register) stores into @register C the result of the bitwise AND of @register A and @register B.
    " r#{v3} = r#{v1} & r#{v2} "
  
  when "bani"
     # bani (bitwise AND immediate) stores into @register C the result of the bitwise AND of @register A and value B.
    " r#{v3} = r#{v1} & #{v2} "
  
  when "borr"
      # borr (bitwise OR @register) stores into @register C the result of the bitwise OR of @register A and @register B.
    " r#{v3} = r#{v1} | r#{v2} "
  
  when "bori"
      # bori (bitwise OR immediate) stores into @register C the result of the bitwise OR of @register A and value B.
    " r#{v3} = r#{v1} | #{v2} "
  
  when "setr"
      # setr (set @register) copies the contents of @register A into @register C. (Input B is ignored.)
    " r#{v3} = r#{v1} "
  
  when "seti"
      # seti (set immediate) stores value A into @register C. (Input B is ignored.)
    " r#{v3} = #{v1} "
   
  when "gtir"
      # gtir (greater-than immediate/@register) sets @register C to 1 if value A is greater than @register B. Otherwise, @register C is set to 0.
    " r#{v3} = #{v1} > r#{v2} ? 1 : 0 "
  
  when "gtri"
      # gtri (greater-than @register/immediate) sets @register C to 1 if @register A is greater than value B. Otherwise, @register C is set to 0.
    " r#{v3} = r#{v1} > #{v2} ? 1 : 0 "
    
  when "gtrr"
      # gtrr (greater-than @register/@register) sets @register C to 1 if @register A is greater than @register B. Otherwise, @register C is set to 0.
    " r#{v3} = r#{v1} > r#{v2} ? 1 : 0 "
         
  when "eqir"
      # eqir (equal immediate/register) sets register C to 1 if value A is equal to register B. Otherwise, register C is set to 0.
    " r#{v3} = #{v1} == r#{v2} ? 1 : 0 "
        
  when "eqri"
      # eqri (equal register/immediate) sets register C to 1 if register A is equal to value B. Otherwise, register C is set to 0.
    " r#{v3} = r#{v1} == #{v2} ? 1 : 0 "
  
  when "eqrr"
      # eqrr (equal register/register) sets register C to 1 if register A is equal to register B. Otherwise, register C is set to 0.
    " r#{v3} = r#{v1} == r#{v2} ? 1 : 0 
    
      if #{v2} == 0
        if @s.size == 0
          puts \"Part 1: \#{r#{v1}}\"
        end
        
        puts \"\#{@s.size.to_s.rjust(10)} - \#{r#{v1}}\" if @s.size % 64 == 0
        
        if @s.include?(r#{v1})
          puts \"Part 2: \#{@last}\"
          exit
        end
        @s.add r#{v1}
        @last = r#{v1}
      end
    "  
  else
    puts "error" #  raise "Error"
  end
end


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
    
    commandQueue << command(verb, v1, v2, v3) 
  end
}

ndigits = commandQueue.size.digits.size 

commandQueue = <<~EOS
while 

  case r#{ip} 
  #{commandQueue.each_with_index.map { |v, i| "when #{i.to_s.rjust(ndigits)} then #{v}"}.join("\n")}
  else
    raise
  end
  
  r#{ip} += 1
    
end
EOS

puts commandQueue
eval(commandQueue)
