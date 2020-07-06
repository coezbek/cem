#
# https://adventofcode.com/2018/day/21 part 1 and part 2 
#
# Does not use any 'cem' functions
#
# Version 3: Put everything into a single Proc (did not help much)
#
require 'set'

lines = File.readlines("inputs/day21_input.txt", chomp: true)

commandQueue = []

@reg = [0,0,0,0,0,0]
@s = Set.new
@last = nil

def command(verb, v1, v2, v3)

  case verb
  when "addr"
  #     addr (add @register) stores into @register C the result of adding @register A and @register B.
    " @reg[#{v3}] = @reg[#{v1}] + @reg[#{v2}] "
  
  when "addi"
  #   addi (add immediate) stores into @register C the result of adding @register A and value B.
    " @reg[#{v3}] = @reg[#{v1}] + #{v2} "
  
  when "mulr"
      # mulr (multiply @register) stores into @register C the result of multiplying @register A and @register B.
    " @reg[#{v3}] = @reg[#{v1}] * @reg[#{v2}] "
  
  when "muli"
     #  muli (multiply immediate) stores into @register C the result of multiplying @register A and value B.
    " @reg[#{v3}] = @reg[#{v1}] * #{v2} "
  
  when "banr"
     #  banr (bitwise AND @register) stores into @register C the result of the bitwise AND of @register A and @register B.
    " @reg[#{v3}] = @reg[#{v1}] & @reg[#{v2}] "
  
  when "bani"
     # bani (bitwise AND immediate) stores into @register C the result of the bitwise AND of @register A and value B.
    " @reg[#{v3}] = @reg[#{v1}] & #{v2} "
  
  when "borr"
      # borr (bitwise OR @register) stores into @register C the result of the bitwise OR of @register A and @register B.
    " @reg[#{v3}] = @reg[#{v1}] | @reg[#{v2}] "
  
  when "bori"
      # bori (bitwise OR immediate) stores into @register C the result of the bitwise OR of @register A and value B.
    " @reg[#{v3}] = @reg[#{v1}] | #{v2} "
  
  when "setr"
      # setr (set @register) copies the contents of @register A into @register C. (Input B is ignored.)
    " @reg[#{v3}] = @reg[#{v1}] "
  
  when "seti"
      # seti (set immediate) stores value A into @register C. (Input B is ignored.)
    " @reg[#{v3}] = #{v1} "
   
  when "gtir"
      # gtir (greater-than immediate/@register) sets @register C to 1 if value A is greater than @register B. Otherwise, @register C is set to 0.
    " @reg[#{v3}] = #{v1} > @reg[#{v2}] ? 1 : 0 "
  
  when "gtri"
      # gtri (greater-than @register/immediate) sets @register C to 1 if @register A is greater than value B. Otherwise, @register C is set to 0.
    " @reg[#{v3}] = @reg[#{v1}] > #{v2} ? 1 : 0 "
    
  when "gtrr"
      # gtrr (greater-than @register/@register) sets @register C to 1 if @register A is greater than @register B. Otherwise, @register C is set to 0.
    " @reg[#{v3}] = @reg[#{v1}] > @reg[#{v2}] ? 1 : 0 "
         
  when "eqir"
      # eqir (equal immediate/register) sets register C to 1 if value A is equal to register B. Otherwise, register C is set to 0.
    " @reg[#{v3}] = #{v1} == @reg[#{v2}] ? 1 : 0 "
        
  when "eqri"
      # eqri (equal register/immediate) sets register C to 1 if register A is equal to value B. Otherwise, register C is set to 0.
    " @reg[#{v3}] = @reg[#{v1}] == #{v2} ? 1 : 0 "
  
  when "eqrr"
      # eqrr (equal register/register) sets register C to 1 if register A is equal to register B. Otherwise, register C is set to 0.
    " @reg[#{v3}] = @reg[#{v1}] == @reg[#{v2}] ? 1 : 0 
    
      if #{v2} == 0
        if @s.size == 0
          puts \"Part 1: \#{@reg[#{v1}]}\"
        end
        
        puts \"\#{@s.size.to_s.rjust(10)} - \#{@reg[#{v1}]}\" if @s.size % 64 == 0
        
        if @s.include?(@reg[#{v1}])
          puts \"Part 2: \#{@last}\"
          exit
        end
        @s.add @reg[#{v1}]
        @last = @reg[#{v1}]
      end
    "
  
  else
    puts "error" #  raise "Error"
  end
end


      
ipid = 0
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
    
    p = command(verb, v1, v2, v3) 
    
    puts p
    
    commandQueue << p
    
  end
}

ippMax = commandQueue.size

commandQueue = "case ipp\n" + commandQueue.each_with_index.map { |v, i|
  "when #{i}\n  #{v}\n"
}.join("\n") + "\nend"

ipp = 0
iteration = 0

puts commandQueue
commandQueue = eval("
while #ipp >= 0 && ipp < ippMax

  @reg[ip] = ipp
  
  #{commandQueue}
  
  ipp = @reg[ip]
  ipp += 1
    
end")

 #{commandQueue} }")


puts @reg.inspect
puts @reg[0]
