#
# https://adventofcode.com/2018/day/24 part 1 and 2
#
# Does not use any cem functions
#

Group = Struct.new("Group", :immuneSystem, :units, :hitPoints, :weakness, :immunities, :damage, :damageType, :initiative) {

  def damageCalc(other)
    damage * units * (other.immunities.include?(damageType) ? 0 : 1) * (other.weakness.include?(damageType) ? 2 : 1)
  end
  
  def effectivePow
    damage * units
  end
}

lines = File.readlines("inputs/day24_input.txt")

groups = []
immuneSystem = false

lines.each { |line|
  line.strip!

  if line =~ /^Immune System:$/
    immuneSystem = true
  elsif line =~ /^Infection:$/
    immuneSystem = false
  elsif line =~ /^([+-]?\d+) units each with ([+-]?\d+) hit points\s*(.*?) with an attack that does ([+-]?\d+) (\w+) damage at initiative ([+-]?\d+)$/
    units = $1.to_i
    hitPoints = $2.to_i
    immunities = []
    weakness = []
    w = $3
    damage = $4.to_i
    damageType = $5
    initiative = $6.to_i
    
    w.gsub(/\(|\)/, "").split("; ").each { |s|
      if s =~ /immune to (.*)/
        immunities = $1.split(", ")
      end
      if s =~ /weak to (.*)/
        weakness = $1.split(", ")
      end
    }
    
    g = Group.new(immuneSystem, units, hitPoints, weakness, immunities, damage, damageType, initiative)
    groups << g
    # puts g.inspect
  elsif line == ""
  
  else
    raise line.inspect
  end    
}

def run(groups)

  max_init = groups.map { |g| g.initiative }.max + 1

  @max_init = max_init

  round = 0
  
  while groups.count { |g| g.immuneSystem } != 0 && groups.count { |g| !g.immuneSystem } != 0

    anyDamage = false  
  
    groups.sort_by! { |g| [-g.damage * g.units, -g.initiative] }
    
    # Target Selection
    attackedGroups = []
    attackPairs = []
    groups.each { |g|
      others = groups.select { |other| g.immuneSystem != other.immuneSystem && !attackedGroups.include?(other) }
      
      groupToAttack = others.sort_by { |other| [-g.damageCalc(other), -other.damage * other.units, -other.initiative] }.first
      
      if groupToAttack && g.damageCalc(groupToAttack) != 0
        attackedGroups << groupToAttack
        attackPairs << [g, groupToAttack]
      end
    }
    
    attackPairs.sort_by! { |x| -x[0].initiative } 
    
    # Attack phase
    attackPairs.each { |x|
      from, to = x
      damage = from.damageCalc(to)
      
      killedUnits = damage / to.hitPoints
      if killedUnits > 0
        anyDamage = true
      end
      to.units -= killedUnits 
          
      if to.units <= 0
        to.units = 0
        groups = groups - [to]
      end
    }

    groups.sort_by! { |g| -(g.immuneSystem ? 1 : 0) * 100000000000 - (g.damage * g.units * max_init + g.initiative)}
    
    # puts round
    round += 1
    # system("cls") if round % 1024 == 0    
    # groups.each { |g| puts g.inspect } if round % 1024 == 0
      
    if !anyDamage 
      groups.each { |g| puts g.inspect }
      return 
    end
  end
  
  groups
end  

tempGroup = groups.map { |g| g.dup }

puts "Part 1: #{run(tempGroup).sum{|g| g.units }}"

def part2(groups)

  minAdd = 1
  
  loop do  
    
    tempGroup = groups.map { |g| g.dup }
  
    tempGroup.each { |g| 
      if g.immuneSystem
        g.damage += minAdd
      end
    }
  
    res = run(tempGroup)
    
    if res == nil
      puts "Boost: #{minAdd} - Got stuck"
    else
      puts "Boost: #{minAdd} - #{res[0].immuneSystem}"  
    
      if res[0].immuneSystem
        return res
      end
    end
  
    minAdd += 1
  end 
end

puts "Part 2: #{part2(groups).sum { |g| g.units }}"