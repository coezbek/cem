
#
# https://adventofcode.com/2018/day/14 part 1 
#
# Does not use any cem functions \o/

recipes = 30121

nexta = 3
storage = [3, 7] 
elves = [0, 1]

i = 2
while i < recipes + 10

  r = storage[elves[0]] + storage[elves[1]]
  
  r.to_s.chars.each { |c|
    storage << c.to_i
    i += 1
    
    if i == recipes + 10
      break;
    end
  }  
    
  elves[0] = (1 + elves[0] + storage[elves[0]]) % storage.size
  elves[1] = (1 + elves[1] + storage[elves[1]]) % storage.size
end

puts storage[-10,15].map { |i| i.to_s}.join 
