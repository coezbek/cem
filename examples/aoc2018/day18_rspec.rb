
#
# https://adventofcode.com/2018/day/18 part 1 and 2
#
# Demonstrates Grid and Object#peql. For a variant without rspec see day18.rb
#

require 'cem'
require 'set'

def run(inputFilename, part1, debug)

  lines = []
  File.readlines(inputFilename, chomp: true).each { |line|
    lines << line.rstrip
  }

  maxY = lines.size
  maxX = lines[0].length
  
  @m = Grid.new(maxX, maxY, '.')
  
  @map = []
  lines.each_with_index { |l, y|
    result = []
    
    l.chars.each_with_index { |c, x|
      result << c
      @m[y,x] = c
    }
    @map << result
  }

  puts "Initial State" if debug
  puts @m if debug
  
  intermediates = Set.new

  startIteration = nil
  periodicity = nil
  tickResultCache = nil
  
  # Read board
  (1..1000000000).each { |i|
  
    @m2 = @m.clone
    
    @map.each_with_index { |l, y|
      
      l.each_with_index { |c, x|
        
        # puts "Adja: #{x} #{y}"
        ajda = @m.adja_index(x,y)
        case @m[y,x]
          when '.'
            @m2[y,x] = ajda.select { |p| @m[p] == '|' }.size >= 3 ? '|' : '.'
          when '|'
            @m2[y,x] = ajda.select { |p| @m[p] == '#' }.size >= 3 ? '#' : '|'             
          when '#'
            @m2[y,x] = ajda.select { |p| @m[p] == '#' }.size >= 1 && ajda.select { |p| @m[p] == '|' }.size >= 1 ? '#' : '.'
        end
        
        puts "#{y} #{x} was #{@m[y,x]} is now #{@m2[y,x]}: #{ajda.inspect}" if debug
        
      }
    }
    
    @m = @m2
    
    if part1 && i == 10
      puts "Part 1: Score after #{i} tick is #{@m.count('#') * @m.count('|')}" # if debug
      break
    end
    
    puts @m if debug if debug
    gets if debug
    
    if !part1 
      tickResult = @m.to_a
      
      if periodicity == nil && tickResultCache == tickResult
        periodicity = i - startIteration
        # puts periodicity
      elsif periodicity
        if ((1000000000 - i) % periodicity) == 0
          break
        end
      end
      
      if startIteration == nil && intermediates.include?(tickResult)
        startIteration = i
        tickResultCache = tickResult
      elsif startIteration == nil
        intermediates.add(tickResult)
      end
      
    end
  }
    
  @m.count('#') * @m.count('|')
end

debug = false

require 'rspec'

RSpec.configure do |config|
  config.color = true # Use color in STDOUT
  config.tty = true # Use color not only in STDOUT but also in pagers and files
  config.formatter = :documentation 
end

describe $__FILE__ do
  
  { 
    "inputs/day18_test.txt"  => [1147, 1],
    "inputs/day18_input.txt" => [589931, 222332],
  }.each_pair { |k,v|
  
    it "testing #{k.inspect} part 1" do
      expect(run(k, true, debug)).to eq(v[0])
    end  
    
    it "testing #{k.inspect} part 2" do
      expect(run(k, false, debug)).to eq(v[1])
    end
  }
    
end

RSpec::Core::Runner.run([$__FILE__])