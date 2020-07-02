
#
# https://adventofcode.com/2018/day/15 part 1 and part 2 
#
# Demonstrate use of Point2D and Grid
#
# This task took me a long time, because I did a array.sort instead of array.sort!
#

require 'cem'

Agent = Struct.new("Agent", :pos, :faction, :hp) 

class Puzzle 

  attr_accessor :persons, :lines, :dirs
  
  def initialize 
    @persons = []
    @grid = []
    @dirs = []
  end
  
  def others(o)
    @persons.select { |p| p.faction != o.faction }
  end
    
  def adjacents(o)
    @dirs.map {|dir| o.pos + dir if @grid[o.pos + dir] == '.'}.compact
  end
    
  def free(pos) 
    @grid[pos] == '.' && @persons.find { |p| p.pos == pos } == nil 
  end

  def printBoard(overlay = nil)

    @grid.data.each_with_index { |l, y|
      l.each_with_index { |c, x|
      
        pos = Point2D.new(x,y)
        
        if overlay && overlay.has_key?(pos)
          print overlay[pos] 
        else
          p = @persons.find { |p| p.pos == pos } 
          if p 
            print p.faction
          else
            print c
          end
        end
      }
      
      puts " " + @persons.select{ |p| p.pos.y == y }.sort_by { |p| p.pos.x }.map {|p| "#{p.faction}(#{p.hp})"}.join(", ")
    }
  end

  def run(inputFilename, debug, elvenPower=3)
  
    # Crucial to sort the directions as given in the problem description
    @dirs = Dirs2D.sort_by { |pos| pos.y * 10000 + pos.x }
    
    lines = []
    File.readlines(inputFilename, chomp: true).each { |line|
      lines << line.rstrip.chars
    }
    
    @grid = Grid.new(lines.size, lines[0].size, ' ')
    @grid.data = lines    
    
    # Read board
    @grid.map_a! { |p, c|
      case c
        when 'E', 'G'
          @persons << Agent.new(p, c, 200)
          next '.'
      end
    }  
    
    generation = -1

    loop do 
    
      system "cls" if debug

      generation += 1
      
      if generation == 0
        puts "Initial Generation with power #{elvenPower}" if debug
      else
        puts "After Generation: #{generation} with power #{elvenPower}" if debug
      end
      
      printBoard if debug
      #gets if debug && generation >= 70
                 
      @persons.sort_by { |cart| cart.pos.y * 10000 + cart.pos.x }.each { |p|
      
        next if !@persons.include?(p)
        
        if @persons.select {|p| p.faction == 'E' }.size == 0 || @persons.select {|p| p.faction == 'G' }.size == 0
          system "cls" if debug
          puts "Before Generation: #{generation} finishes" if debug
          printBoard if debug
          
          puts "#{generation} * #{@persons.sum {|p| p.hp }} = #{generation * @persons.sum {|p| p.hp }}"
          return (@persons[0].faction == 'E' ? 1 : -1) * generation * @persons.sum {|p| p.hp }
        end
      
        # puts p.inspect
      
        # Moving
        nearby = @persons.select { |o| o.faction != p.faction && dirs.any? { |dir| p.pos + dir == o.pos } }.group_by { |o| o.hp }.min_by { |k,v| k } 
        
        if nearby == nil || nearby.size == 0
          distancemap = Array.new(@grid.data.size) { Array.new(@grid[0].size)}
          
          targets = Set.new(others(p).map {|o| adjacents(o)}.flatten)
          
          s = p.pos
          distancemap[s.y][s.x] = 0
          bfs = []
          bfsNG = [s]
          found = []
          
          target = []
          while bfsNG.size > 0 && found.size == 0
            bfs = bfsNG
            bfsNG = []
            while bfs.size > 0
              
              s = bfs.shift
                          
              dirs.each { |dir|
                
                s2 = s + dir
               
                if free(s2)
                  
                  if distancemap[s2.y][s2.x] == nil
                    bfsNG << s2 
                    #puts " free " + s2.inspect + " - " + dir.to_s
                    distancemap[s2.y][s2.x] = dir.flip
                  end
                  
                  if targets.include?(s2)
                    found << s2
                  end            
                end
              }
            end
          end
          
          if found.size > 0
            found.sort_by! { |p| p.y * 10000 + p.x }
            
            overlay = {}
            
            if found.size > 1              
              found.each { |p| overlay[p] = '+' }
              overlay[found[0]] = 'X'
            end
            
            target = found[0]
            #puts "  Target: #{target}"
            
            lastMove = nil
            
            while target && target != p.pos
              lastMove = distancemap[target.y][target.x]
              #puts target.inspect
              overlay[target] = 'x'
              target = target + lastMove
            end

            #if generation >= 77
            #  system('cls')
            #  printBoard(overlay)
            #  puts found.inspect
            #  gets
            #end
            
            p.pos = p.pos + lastMove.flip if lastMove
            #puts "  Moved to #{p.pos}"
          end
        end
        
        # Fighting
        nearby = @persons.select { |o| o.faction != p.faction && dirs.any? { |dir| p.pos + dir == o.pos } }.group_by { |o| o.hp }.min_by { |k,v| k } 
        if nearby && nearby.size > 0 
          nearby = nearby[1]
        
          #puts "Fighting"
          nearby.sort_by! { |cart| cart.pos.y * 10000 + cart.pos.x }
        
          if p.faction == 'E'
            nearby[0].hp -= elvenPower
          else
            nearby[0].hp -= 3
          end           
            
          if (nearby[0].hp <= 0)
            @persons -= [nearby[0]]
            
            if nearby[0].faction == 'E' && elvenPower > 3
              return -1
            end            
          end
        end
        
      }
        
      
    end
  end

end

part1 = {
  # "inputs/day15_input14.txt" => -248848,
  # "inputs/day15_input13.txt" => -261855,
  # "inputs/day15_input12.txt" => -189000,
  # "inputs/day15_input11.txt" => '?',
  # "inputs/day15_input10.txt" => -261855,
  # "inputs/day15_input2.txt" => -27730,
  # "inputs/day15_input3.txt" => -18740,
  # "inputs/day15_input4.txt" =>  36334,
  # "inputs/day15_input5.txt" =>  39514,
  # "inputs/day15_input6.txt" => -27755,
  # "inputs/day15_input7.txt" => -28944,
   "inputs/day15_input.txt" => '?'
}

debug = false

part1.each_pair { |k,v|

  power = 3
  is = Puzzle.new.run(k, debug, power)
  
  puts "Part 1: #{k} == #{is}"
  if is != v && v != '?'
    puts "#{k} should be #{v}, but is #{is}"
    exit
  end
}


part2 = {
  "inputs/day15_input.txt" => '?'
}

part2.each_pair { |k,v|

  power = 4
  while true
    # puts "Elven Power: #{power} "
    is = Puzzle.new.run(k, debug, power)
    power += 1
    if is > 0 
      break;
    end
  end
  
  puts "Part 2: #{k} == #{is}"
  if is != v && v != '?'
    puts "#{k} should be #{v}, but is #{is}"
    exit
  end
}
