puts '... methods.rb'.light_black

def combat(a, b)
  combat_round = 1
  history      = [] # Stores the list of abilities used by characters. Example: [1]

  # TODO: Break this down into different actions. We cannot just have a simple 'combat' method of course...
  while true
    loser  = nil
    winner = nil

    puts "\nRound #{combat_round}"

    ########
    # Hook #
    ########
    # Reset the current hash.

    ###########################
    # Initialize Combat Round #
    ###########################
    # TODO: Move this over to the Character model.
    # Idea: We may want to support 'current' systematically. It is that important to the architecture.
    [a, b].each do |c|
      c['current'] = {}
      # This is all we need to save for now for the 'Ferocity' special ability.
      c['current']['speed'] = c['speed']
    end

    ########
    # Hook #
    ########
    # TODO: Move this over to the Character model.
    # TODO: Name all of these different hooks...
    # Immediately apply certain modifiers.
    [a, b].each do |c|
      # [FEROCIOUS] Per definition, the value of the 'ferocious' key must be '{'speed' => x}', where x is an integer.
      if c['statuses'].has_key?('ferocious')
        c['current']['speed'] = c['statuses']['ferocious']['speed']
        c['statuses'].delete('ferocious')
        puts "Apply the effects of the 'ferocious' status to #{c['name']}.".light_black
      end
    end

    ###########
    # Potions #
    ###########
    # You can only use one potion per combat round.

    #####################
    # Character A Speed #
    #####################
    # Speed (sp): These abilities can be used at the start of a combat round (before you roll for attack speed), and will eventually influence how many dice you can roll or reduce the number of dice your opponent can roll for speed. You can only use one speed ability per combat round.
    # This is how the UI should work right after a round starts:
    # $ Choose a special ability:
    # $ 1 - None
    # $ 2 - Ability A
    # $ 3 - Ability B
    # $ ...
    # TODO: These can all be performed on the Character level... or not? Hooks may alter this...
    numbers = [roll, roll, a['current']['speed']]
    attack_speed_a = numbers.sum
    puts "... #{a['name']} Attack Speed: #{numbers} => #{attack_speed_a}".light_black

    #####################
    # Character B Speed #
    #####################
    numbers = [roll, roll, b['current']['speed']]
    attack_speed_b = numbers.sum
    puts "... #{b['name']} Attack Speed: #{numbers} => #{attack_speed_b}".light_black

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

        puts "... #{loser['name']} takes #{damage} points of health damage."

        if loser['health'] <= 0
          puts "... #{loser['name']} has been defeated."
          break
        end

        ########
        # Hook #
        ########
        # Winner damages loser.
        # Special ability: 'ferocity'
        # Ferocity: If Mauler wins a combat round and inflicts health damage on your hero, the beast automatically raises its _speed_ to 7 for the next combat round.
        if winner['special_abilities'].has_key?('ferocity')
          winner['statuses']['ferocious'] = {'speed' => 7} # , 'turns' => 1
          puts "#{winner['name']} is ferocious!".light_black
        end

        # Special ability: 'venom'
        # if winner['special_abilities'].include?('venom') && !loser['statuses'].include?('poisoned')
        #   loser['statuses'].push('poisoned')
        #   puts "#{loser['name']} is poisoned!"
        # end
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
    # if a['statuses'].include?('poisoned')
    #   a['health'] -= 2
    #   puts "... #{a['name']} takes 2 damage due to being poisoned."
    # 
    #   if a['health'] <= 0
    #     puts "... #{a['name']} has been defeated."
    #     break
    #   end
    # end

    # if b['statuses'].include?('poisoned')
    #   b['health'] -= 2
    #   puts "... #{b['name']} takes 2 damage due to being poisoned."
    # 
    #   if b['health'] <= 0
    #     puts "... #{b['name']} has been defeated."
    #     break
    #   end
    # end

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
