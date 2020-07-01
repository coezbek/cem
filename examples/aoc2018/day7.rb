
#
# https://adventofcode.com/2018/day/7 part 1 and 2
#
# Does not use any cem functions \o/ 
# 

require 'set'

Worker = Struct.new("Worker", :readyAt, :workingOn)

def read
  input = File.readlines("inputs/day7_input.txt", chomp: true)

  @edges = {}
  @chars = Set.new

  input.each { |line|

    if line =~ /^Step (.+) must be finished before step (.+) can begin.$/
      to   = $1
      from = $2    
      
      @chars.add(to)
      @chars.add(from)
      
      (@edges[from] ||= []) << to
    end    
    
    @chars.each { |c| @edges[c] ||= [] }
  }
end

def anyWorkerReady 
  return @idleWorkers.size > 0
end

def availableWork
  return @chars.select { |c| @edges.include?(c) && @edges[c].size == 0 }.sort
end

def anyWorkAvailable
  return availableWork.size > 0
end

def timeStep
  
  puts "#{@timeNow}: #{@busyWorkers.inspect}" if $DEBUG
  
  w = @busyWorkers.min_by { |w| w.readyAt }
  @timeNow = w.readyAt
  @busyWorkers -= [w]
  @idleWorkers += [w]
  
  c = w.workingOn
    
  @result += c  
    
  @edges.update(@edges) { |k,v|
    v - [c]
  }
end
  
def scheduleWork

  nextTask = availableWork.first
  
  w = @idleWorkers.pop
  @busyWorkers += [w]
  w.workingOn = nextTask
  w.readyAt = @timeNow + 61 + nextTask.ord - 'A'.ord
  @edges.delete(nextTask)

  puts "Scheduling #{nextTask} to be ready at #{w.readyAt}" if $DEBUG
  
end
  
def process(parallelism)

  read()

  @timeNow = 0
  @result = ""

  @busyWorkers = []
  @idleWorkers = []
  parallelism.times { @idleWorkers << Worker.new(0, '') }

  loop do

    while (!anyWorkerReady || !anyWorkAvailable) && @busyWorkers.size > 0
      timeStep
    end
    
    if !anyWorkAvailable
      break
    end
    
    scheduleWork 
    
  end
    
  puts "Parallelism: #{parallelism}"
  puts @result
  puts @timeNow
  
end

process(1)
process(5)