#
# https://adventofcode.com/2018/day/23 part 1 and part 2 
#
# Uses Point3D. I probably need to revisit how to subclass Point3D, Point2D.
#
require 'cem'

Bot = Struct.new("Bot", :x, :y, :z, :r) {
  
  def [](i)
    case i
      when 0
        x
      when 1
        y
      when 2
        z
      when 3 
        r
      else 
        raise
    end
  end
  
}

def manhattan(other, bot)
  (other.z - bot.z).abs + (other.y - bot.y).abs + (other.x - bot.x).abs
end

def manhattan_box(bot, min, max)

  result = (0..2).sum { |i| 
    if bot[i] >= min[i] && bot[i] <= max[i]
      0
    elsif bot[i] < min[i]
      min[i] - bot[i]
    else
      bot[i] - max[i]
    end
  }
  
  #puts "#{bot.inspect} - #{min} - #{max} - #{result}"
  return result
  
end

lines = File.readlines("inputs/day23_input.txt", chomp: true)

input = []

lines.each { |line|

  if line =~ /^pos=<([+-]?\d+),([+-]?\d+),([+-]?\d+)>, r=([+-]?\d+)$/
    v1 = $1.to_i
    v2 = $2.to_i
    v3 = $3.to_i
    v4 = $4.to_i
        
    input << Bot.new(v1,v2,v3,v4)
  end    

}

#
# Part I
#
bot = input.max_by { |bot| bot.r }

strength = 0
input.each { |other|
  
  if manhattan(bot, other) <= bot.r
    strength += 1
  end
}

puts "Part I: #{strength}"

#
# Part II
#

# Start with the largest group we can trivially find  
best = []
bestScore = -1

min = Point3D.new(*[0,1,2].map { |i| input.map { |b| b[i] }.min })
max = Point3D.new(*[0,1,2].map { |i| input.map { |b| b[i] }.max })

todo = []

# todo == [ queue of [Box min, Box max, number of elements fully covering box, number of elements still under considerations] ]
todo << [min, max, 0, input]

i = 0
while todo.size > 0

  mi, ma, covered, bots = todo.shift
  
  puts "Iteration #{i} - Still todo: #{todo.size} - Cover: #{covered} Bots: #{bots.size} Cur Size: #{(ma-mi).manhattan} - BestScore: #{bestScore}" if i % 128 == 0
  i += 1

  if mi == ma
    hit, miss = bots.partition { |bot| manhattan(bot, mi) <= bot.r }
    
    if bestScore < covered + hit.size       
      bestScore = covered + hit.size
      best = [mi]
    elsif bestScore == covered + hit.size
      best << mi
    end
    
    next
  end
  
  # Which bots do touch the current min-max box
  hit, miss = bots.partition { |bot| manhattan_box(bot, mi, ma) <= bot.r }
  next if covered + hit.size < bestScore # We don't have to dig in, if we have a better high score anyway
  
  # Which bots do completely cover the entire box and which don't? Check 8 corners to find out
  corners = (0..7).map { |i| Point3D.new(i & 4 == 0 ? mi.x : ma.x, i & 2 == 0 ? mi.y : ma.y, i & 1 == 0 ? mi.z : ma.z) }
  total, partial = hit.partition { |bot| corners.count { |c| manhattan(bot, c) <= bot.r } == 8 }

  # Split the largest dimension of the box in half (mi to midI, midA to ma) 
  minDim = [0,1,2].max_by { |i| ma[i] - mi[i] }
  
  midI = ma.clone
  midI[minDim] = mi[minDim] + (ma[minDim] - mi[minDim]) / 2
  
  midA = mi.clone
  midA[minDim] = mi[minDim] + (ma[minDim] - mi[minDim]) / 2 + 1
    
  todo << [mi, midI, covered + total.size, partial]
  todo << [midA, ma, covered + total.size, partial]
  
  todo.sort_by! { |t| -(t[2] + t[3].size) * (max-min).manhattan + manhattan(t[0], t[1]) } if i % 4 == 0 
end

puts "Best Positions: " + best.to_s
puts "Number of Bots In Range: #{bestScore}"
puts "Lowest Manhattan Distance to 0,0,0: #{best.map { |b| b.manhattan }.min}"

  

    


