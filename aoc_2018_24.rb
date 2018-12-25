IMMUNE = "504 units each with 1697 hit points (weak to fire; immune to slashing) with an attack that does 28 fire damage at initiative 4
7779 units each with 6919 hit points (weak to bludgeoning) with an attack that does 7 cold damage at initiative 2
7193 units each with 13214 hit points (weak to cold, fire) with an attack that does 12 slashing damage at initiative 14
1898 units each with 3721 hit points (weak to bludgeoning) with an attack that does 16 cold damage at initiative 20
843 units each with 3657 hit points (immune to slashing) with an attack that does 41 cold damage at initiative 17
8433 units each with 3737 hit points (immune to radiation; weak to bludgeoning) with an attack that does 3 bludgeoning damage at initiative 8
416 units each with 3760 hit points (immune to fire, radiation) with an attack that does 64 radiation damage at initiative 3
5654 units each with 1858 hit points (weak to fire) with an attack that does 2 cold damage at initiative 6
2050 units each with 8329 hit points (immune to radiation, cold) with an attack that does 36 radiation damage at initiative 12
4130 units each with 3560 hit points with an attack that does 8 bludgeoning damage at initiative 13"

INFECTION = "442 units each with 35928 hit points with an attack that does 149 bludgeoning damage at initiative 11
61 units each with 42443 hit points (immune to radiation) with an attack that does 1289 slashing damage at initiative 7
833 units each with 6874 hit points (weak to slashing) with an attack that does 14 bludgeoning damage at initiative 15
1832 units each with 61645 hit points with an attack that does 49 fire damage at initiative 9
487 units each with 26212 hit points (weak to fire) with an attack that does 107 bludgeoning damage at initiative 16
2537 units each with 18290 hit points (immune to cold, slashing, fire) with an attack that does 11 fire damage at initiative 19
141 units each with 14369 hit points (immune to bludgeoning) with an attack that does 178 radiation damage at initiative 5
3570 units each with 34371 hit points with an attack that does 18 radiation damage at initiative 10
5513 units each with 60180 hit points (weak to radiation, fire) with an attack that does 16 slashing damage at initiative 1
2378 units each with 20731 hit points (weak to bludgeoning) with an attack that does 17 radiation damage at initiative 18"

@infection = []
@immune = []

def parse_data
  [IMMUNE, INFECTION].each_with_index do |data, j|
    data_arr = j == 0 ? @immune : @infection
    data.split("\n").each_with_index do |group, i|
      immune = {}
      arr = group.split(" ")
      immune[:index] = i+1
      immune[:name] = j == 0 ? "immune" : "infection"
      values = arr.select {|x| x.to_i > 0}.map(&:to_i)
      immune[:units] = values[0]
      immune[:hit_points] = values[1]
      immune[:attack] = values[2]
      immune[:initiative] = values[3]
      immune[:attack_type] = arr[arr.index(values[2].to_s)+1]

      open_parens_idx = group.index("(")
      closed_parens_idx = group.index(")")
      if open_parens_idx
        parens_string = group[open_parens_idx+1..closed_parens_idx-1]
        a_ = parens_string.split(";")
        a_.each do |a|
          if a.strip[0..3] == "weak"
            immune[:weakness] = []
            a.sub("weak to","").split(" ").each do |c|
              immune[:weakness] << c.sub(",","").strip
            end
          else
            immune[:immunity] = []
            a.sub("immune to","").split(" ").each do |c|
              immune[:immunity] << c.sub(",","").strip
            end
          end
        end
      end

      data_arr << immune
    end
  end
end

def attack_points(immunity, units, attack)
  immunity*units*attack
end


def damage_hash(group1, group2)

  attack_points = {}
  group1.each_with_index do |group_i, i|
    group2.each_with_index do |group_j, j|
      next unless group_i && group_j
      immunity = if group_j[:weakness].to_a.include?(group_i[:attack_type])
        2
      elsif group_j[:immunity].to_a.include?(group_i[:attack_type])
        0
      else
        1
      end
      attack_points["#{group_i[:name]}-#{i+1}->#{group_j[:name]}-#{j+1}"] = attack_points(immunity, group_i[:units], group_i[:attack])
    end
  end
  attack_points
end

def effective_power_rank
  return unless @immune.length > 0 && @infection.length > 0
  (@immune + @infection).compact.sort_by {|hash| hash[:units]*hash[:attack]}.reverse.map {|hash| "#{hash[:name]}-#{hash[:index]}"}
end

def max_damage_hash(damage_hash)
  attacked = []
  max_damage_hash = {}

  effective_power_rank.each do |group|
    name, i = group.split("-")
    i = i.to_i
    new_damage_hash = damage_hash.select {|k,v| k.split("->")[0] == "#{name}-#{i}"}
    new_damage_hash = new_damage_hash.reject {|k,v| attacked.include?(k.split("->")[1])}
    new_damage_hash = new_damage_hash.select {|k,v| v == new_damage_hash.values.max}
    damage = new_damage_hash.values.max
    next if  new_damage_hash.length == 0
    if new_damage_hash.length == 1
      max_damage_hash["#{name}-#{i}"] = [new_damage_hash.to_a.first.first.split("->")[1], new_damage_hash.to_a.first.last]
      attacked << new_damage_hash.to_a.first.first.split("->")[1]
    else
      targets = new_damage_hash.map {|k,v| k.split("->")[1]}
      effective_powers = []
      initiatives = []
      targets.each do |target|
        hash = eval("@#{target.split("-")[0]}")[target.split("-")[1].to_i-1]
        effective_powers << [target, hash[:units]*hash[:attack]]
        initiatives << [target, hash[:initiative]]
      end

      # rank by effective power
      max_effective_powers = effective_powers.select {|a,b| b == effective_powers.transpose[1].max}
      if max_effective_powers.length == 1
        max_damage_hash["#{name}-#{i}"] = [max_effective_powers.first.first, damage]
        attacked << max_effective_powers.first.first
      else
        highest_init = initiatives.select {|a,b| max_effective_powers.transpose[0].include?(a)}
          .sort_by {|_, initiative| -initiative}.first.first
        max_damage_hash["#{name}-#{i}"] = [highest_init, damage]
        attacked << highest_init
      end

    end
  end
  max_damage_hash
end


def attack(max_damage_hash)
  max_damage_hash.sort_by { |attacker,_| -eval("@#{attacker.split("-")[0]}")[attacker.split("-")[1].to_i-1][:initiative] }
    .each do |attacker, (defender,damage)|

      damage_hash = damage_hash(@immune, @infection).merge(damage_hash(@infection, @immune))
      defender_name, defender_group = defender.split("-")
      defender_arr = eval("@#{defender_name}")
      defender_hash = defender_arr[defender_group.to_i-1]

      if damage_hash["#{attacker}->#{defender}"].nil?
        next
      end
      defender_hash[:units] -= damage_hash["#{attacker}->#{defender}"]/defender_hash[:hit_points]
      if defender_hash[:units] <= 0
        defender_arr[defender_group.to_i-1] = nil
      end
    end
end

parse_data


# 1

until @immune.compact.length == 0 || @infection.compact.length == 0
  damage_hash = damage_hash(@immune, @infection).merge(damage_hash(@infection, @immune))
  attack(max_damage_hash(damage_hash))
end

p @infection.map {|group| group ? group[:units] : 0}.inject(:+)