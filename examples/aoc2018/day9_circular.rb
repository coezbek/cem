
#
# https://adventofcode.com/2018/day/9 part 1 and part 2
#
# Does not use any cem functions \o/ 
# 
# Unfinished attempt to develop a circular array
# 

players = 428 
marbles = 7082500

#players = 10 
#marbles = 1618

scores = [0] * 428

nexta = 3
lasta = 0
storage = [1, 2, 1] 
current = 1

#
#
# Caveats:
#   - When writing to indices greater than @size, the CircularArray does not expand, but the index wraps.
#
class CircularArray 

  attr_accessor :data
  attr_reader  :size, :start

  def initialize(initialSize)
	@data = Array.new(initialSize)
	@size = 0
  end
  
  def index(index)
    return (@start + index) % @size
  end
  
  def [](i)
    return @data[index(i)]
  end
  
  def []=(i, newValue)
    @data[index(i)] = newValue
  end
  
  def each
    (0..@size).each do |x|
      yield self[x]
    end
  end
  
  def each_with_index
    (0..@size).each do |x|
      yield self[x], x
    end
  end
  
  def <<(newValue)
    if @size == @data.size
      @data.insert(index(@size) + 1, [nil] * @size)
    end	
    
	@data[index(@size)] = newValue
	@size += 1	
  end
  
  
end


while nexta < marbles 

  if nexta / 1000 != lasta
    lasta = nexta / 1000
	puts lasta * 1000
  end
  
  n = storage.size
  if nexta % 23 == 0
  
    current = (current + n - 7) % n
    worth = nexta + storage.delete_at(current)
    scores[nexta % players] += worth
    
    if worth == marbles
      break;
    end
  
  else
  
    if nexta % 23 == 1 && current + 46 < n && nexta + 22 < marbles
    
      current += 2
      
      storage.insert(current, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
      (0..21).each { |i|
      
        # puts storage[current..current + 40].inspect
      
        storage[current + i * 2] = nexta
        nexta += 1
        storage[current + i * 2 + 1] = storage[current + 20 + i]
        

      }
      current += 42
      nexta -= 1
    
    else
      current = (current + 2) % n
      storage.insert(current, nexta)
    end
    
  end
  
  nexta += 1
  
end
  
  
puts scores.max