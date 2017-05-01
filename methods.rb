puts '... methods.rb'.light_black

def combat(a, b)
  combat_round = 1

  while true
    loser  = nil
    winner = nil

    puts "\nRound #{combat_round}"

    ###########
    # Potions #
    ###########
    # You can only use one potion per combat round.

    ########
    # Hook #
    ########
    # Speed (sp): These abilities can be used at the start of a combat round (before you roll for attack speed), and will eventually influence how many dice you can roll or reduce the number of dice your opponent can roll for speed.
    # You can only use one speed ability per combat round.
    # This is how the UI should work right after a round starts:
    # $ Choose a special ability:
    # $ 1 - None
    # $ 2 - Ability A
    # $ 3 - Ability B
    # $ ...

    attack_speed_a = roll + roll + a['speed']
    attack_speed_b = roll + roll + b['speed']

    if attack_speed_a > attack_speed_b
      loser  = b
      winner = a
    elsif attack_speed_b > attack_speed_a
      loser  = a
      winner = b
    end

    ########
    # Hook #
    ########
    # Modifier (mo): Modifier abilities allow you to boost your attribute scores or influence dice that you aheva lready rolled.
    # You can use as many different modifier abilities as you wish during a combat round.
    # THIS WILL BE A PAIN IN THE ASS!

    if winner
      ########
      # Hook #
      ########
      # Combat (co): These abilities are used either before or after you (or your opponent) roll for damage. Usually these will increase the number of dice you can roll or allow you to block or dodge your opponent's attacks.
      # You can only use one combat ability per combat round.
      damage_score = winner['brawn'] > winner['magic'] ? roll + winner['brawn'] : roll + winner['magic']

      damage = damage_score - loser['armour']

      if damage > 0
        # loser['health'] = loser['health'] - damage < 0 ? 0 : loser['health'] - damage
        loser['health'] -= damage

        puts "#{loser['name']} takes #{damage} points of health damage."

        if loser['health'] <= 0
          puts "#{loser['name']} has been defeated."
          break
        end

        ########
        # Hook #
        ########
        # Winner damages loser.
        # Special ability: 'venom'
        if winner['special_abilities'].include?('venom') && !loser['statuses'].include?('poisoned')
          loser['statuses'].push('poisoned')
          puts "#{loser['name']} is poisoned!"
        end
      end
    end

    ########
    # Hook #
    ########
    # Passive (pa): Passive abilities (such as 'bleed' and 'venom') are typically applied at the end of a combat round, once you or your opponent has taken health damage. These abilities happen automatically, based on their description.

    ########
    # Hook #
    ########
    # Apply damage of passive effects, such as 'bleed' or 'venom'.
    # THIS IS HORRENDOUS!!!
    if a['statuses'].include?('poisoned')
      a['health'] -= 2
      puts "#{a['name']} takes 2 damage due to being poisoned."

      if a['health'] <= 0
        puts "#{a['name']} has been defeated."
        break
      end
    end

    if b['statuses'].include?('poisoned')
      b['health'] -= 2
      puts "#{b['name']} takes 2 damage due to being poisoned."

      if b['health'] <= 0
        puts "#{b['name']} has been defeated."
        break
      end
    end

    combat_round += 1
  end
end

# @author Vilmos Csizmadia
# @version 20170430
def hp(string)
  puts ''
  puts ('*' * (string.length + 4)).light_black
  puts "# #{string} #".light_black
  puts ('*' * (string.length + 4)).light_black
end

def roll
  rand(6) + 1
end
