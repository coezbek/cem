
#
# https://adventofcode.com/2018/day/12 part 1 and part 2
#
# Does not use any cem functions \o/ 
#

input = {}

start = ""
File.readlines("inputs/day12_input.txt", chomp: true).each { |line|

  if line =~ /^initial state\: (.*)$/
    start = $1
  end    

  if line =~ /^(.....) => (.)$/
    input[$1] = $2
  end    

}

result = ''
previous_score = nil
delta = nil
offset = 0
max_gen = 50000000000

(1..max_gen).each { |gen|

  start = "...." + start + "...."
  offset -= 2
  
  result = ''
  (0...start.length - 4).each { |i|
    result += input.has_key?(start[i,5]) ? input[start[i,5]] : '.'
  }

  score = 0
  (0...result.length).each { |i|  
    score += i + offset if result[i] == '#'
  }

  # puts score
  if gen == 20 
    puts "Part 1: Generation #{gen} has score #{score}" 
  end
  
  if delta && (score - previous_score == delta)
    puts 
    puts "Part 2: Generation #{gen} has score #{score} with same delta as before (#{delta})."
    puts "If continued to gen #{max_gen} the score would be #{(max_gen - gen) * delta + score}"
    exit
  end
  
  delta = score - previous_score if previous_score
  previous_score = score
  
  start = result
}

