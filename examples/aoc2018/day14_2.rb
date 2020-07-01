
#
# https://adventofcode.com/2018/day/14 part 2 
#
# Does not use any cem functions \o/


#recipes = "51589"
#recipes = "59414"
#recipes = "652601"

recipes =  "030121"

r2 = recipes.chars.map {|c| c.to_i}

storage = [0] * 100000000
storage[0] = 3
storage[1] = 7

e0 = 0
e1 = 1

comp = [0] * r2.length

i = 2
while true

  puts i if i % 100000 == 0

  s0 = storage[e0]
  s1 = storage[e1]
    
  r = s0 + s1
    
  if r >= 10
    storage[i] = 1
    i+=1
    
    comp << 1
    comp = comp.drop(1)   
    
    if comp == r2
      puts i - recipes.length
      exit
    end
    storage[i] = r - 10
    i+=1
    comp << r - 10
    comp = comp.drop(1)   

    if comp == r2
      puts i - recipes.length
      exit
    end
  else
    storage[i] = r
    i+=1
    comp << r
    comp = comp.drop(1)  

    if comp == r2
      puts i - recipes.length
      exit
    end
    
  end
  
  e0 = (1 + e0 + s0) % i
  e1 = (1 + e1 + s1) % i
end

