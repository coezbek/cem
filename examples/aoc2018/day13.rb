
#
# https://adventofcode.com/2018/day/13 part 1 and 2
#
# Demonstrates Point2D

require 'cem'
  
Cart = Struct.new("Cart", :dir, :pos, :history)
carts = []
lines = []

# Read board
File.readlines("inputs/day13_input.txt", chomp: true).each { |line|
  lines << line.rstrip
}

# Read carts
lines.each_with_index { |l, y|
  l.chars.each_with_index { |c, x|
    case c
      when '^', 'v'
        lines[y][x] = '|'
        carts << Cart.new(c, Point2D.new(x,y), 2)
      when '>', '<'
        lines[y][x] = '-'
        carts << Cart.new(c, Point2D.new(x,y), 2)
    end
  }
}

def printBoard(lines, carts)

  lines.each_with_index { |l, y|
    l.chars.each_with_index { |c, x|
     
      a = carts.find { |cart| cart.pos == Point2D.new(x,y) } 
      if a 
        print a.dir
      else
        print c
      end
    }
    print "\n"
  }
end

generation = 0
first = true

loop do 

  generation += 1
  
  if carts.size == 1
    puts "Last crash at: #{carts[0].pos}"
    exit
  end
  
  # system "cls"
  # puts generation
  # puts carts.inspect
  # printBoard(lines, carts)
  # gets  
  
  carts.sort_by { |cart| cart.pos.y * 10000 + cart.pos.x }.each { |cart|
    
    cart.pos += Point2D.from_s(cart.dir)
        
    if crash = carts.find { |c2| cart != c2 && cart.pos == c2.pos }
      if first
        puts "First crash at: #{cart.pos}"
        first = false
      end
  
      carts.delete(crash)
      carts.delete(cart)
      
    end
        
    track = lines[cart.pos.y][cart.pos.x]
      
    case cart.dir
      
      when '>'      
        
        case track
          when '\\'
            cart.dir = 'v'
          when '/'
            cart.dir = '^'
          when '+'
            
            cart.history = (cart.history + 1) % 3
            case cart.history 
              when 1
                # nothing
              when 2
                cart.dir = 'v'
              when 0
                cart.dir = '^'
            end
          
        end
            
      when '<'        
        case track
        when '\\'          
          cart.dir = '^'
        when '/'
          cart.dir = 'v'
        when '+'
          
          cart.history = (cart.history + 1) % 3
          case cart.history
            when 1
              # nothing
            when 2
              cart.dir = '^'
            when 0
              cart.dir = 'v'
          end
        
      end 
      when '^'      
        case track
          when '\\'          
            cart.dir = '<'
          when '/'
            cart.dir = '>'
          when '+'
            
            cart.history = (cart.history + 1) % 3
            case cart.history
              when 1
                # nothing
              when 2
                cart.dir = '>'
              when 0
                cart.dir = '<'
            end
          
        end 
      when 'v'        
        case track
          when '\\'          
            cart.dir = '>'
          when '/'
            cart.dir = '<'
          when '+'
            
            cart.history = (cart.history + 1) % 3
            case cart.history
              when 1
                # nothing
              when 2
                cart.dir = '<'
              when 0
                cart.dir = '>'
            end
          
        end 
    end    
  }
    
  
end
