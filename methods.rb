puts '... methods.rb'.light_black

def combat(a, b)
  @history = []
  @round   = 1

  # TODO: Break this down into different actions. We cannot just have a simple 'combat' method of course...
  while true
    loser  = nil
    winner = nil

    puts "\nRound #{@round}"

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

    skill_selector(a, ['sp']) # ['mo', 'sp']

    # TODO: These can all be performed on the Character level... or not? Hooks may alter this...
    numbers = [roll(a, nil), roll(a, nil), a['current']['speed']]
    attack_speed_a = numbers.sum
    puts "... #{a['name']} Attack Speed: #{numbers} => #{attack_speed_a}".light_black

    #####################
    # Character B Speed #
    #####################
    skill_selector(b, ['sp'])

    numbers = [roll(b, nil), roll(b, nil), b['current']['speed']]
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
      puts "... #{winner['name']} has a higher attack speed.".light_black

      # For now, only the winner gets to select an Ability.
      skill_selector(winner, ['mo'])

      ########
      # Hook #
      ########
      # Combat (co): These abilities are used either before or after you (or your opponent) roll for damage. Usually these will increase the number of dice you can roll or allow you to block or dodge your opponent's attacks.
      # You can only use one combat ability per combat round.
      numbers      = [roll(winner, 'damage'), winner['magic'] > winner['brawn'] ? winner['magic'] : winner['brawn']]
      damage_score = numbers.sum
      damage       = damage_score - loser['armour'] > 0 ? damage_score - loser['armour'] : 0
      puts "... #{winner['name']} Damage Score: #{numbers} => #{damage_score} => Damage: #{damage}".light_black

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

    @round += 1
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

# This is a flexible method for rolling a die and potentially influencing it with Abilities.
# @author Vilmos Csizmadia
# @version 20170514
def roll(character, roll_for = nil)
  character['roll'] = rand(6) + 1

  ########
  # Hook #
  ########
  puts "... #{character['name']} rolled a [#{character['roll']}]#{roll_for ? " for #{roll_for}" : nil}.".light_black

  # A roll for damage may be modified with an available 'mo' Ability:
  if roll_for == 'damage'
    skill_selector(character, ['mo'])
  end

  character['roll']
end

# This can be called at any time during combat to bring up the ability selector. 
# @author Vilmos Csizmadia
# @param character [Character] the Characters for whom the ability selector is invoked
# @param types [Array] the permitted types of Abilities for the selector
# @version 20170514
def skill_selector(character, types = [])
  abilities = []

  # Determine which Abilities are (still) usable.
  character['special_abilities'].each do |key, ability|
    if types.include?(ability['type'])
      # Unless:
      # - The Ability can only be used once per combat and it has already been used...
      # - The Ability can only be used once per combat round and it has already been used this round...
      unless (
        ability['is_usable_once_per_combat'] && @history.any? {|h| h['character_id'] == character['id'] && h['ability_id'] == ability['id']}
      ) || (
        ability['is_usable_once_per_round'] && @history.any? {|h| h['character_id'] == character['id'] && h['ability_id'] == ability['id'] && h['round'] == @round}
      )
        abilities << ability
      end
    end
  end

  puts @history.inspect.light_black
  puts abilities.inspect.light_black

  if abilities.any?
    puts 'Select an ability to use:'

    abilities.each do |a|
      puts "#{a['id']}\t#{a['name']}"
    end

    id = gets.strip.to_i

    if ability = character['special_abilities'].detect {|key, a| a['id'] == id}
      # Ability is currently: ["fearless", {"id"=>3, "is_usable_once_per_combat"=>true, "name"=>"Fearless"}]
      # Needs to be: {"id"=>3, "is_usable_once_per_combat"=>true, "name"=>"Fearless"}
      puts ability.inspect.yellow
      ability = ability[1] # This is so ugly... we MUST refactor this mess...
      puts ability.inspect.green
      puts "You selected #{ability['name']}.".light_black

      ###################
      # Begin Abilities #
      ###################
      # Dominate (mo): Change the result of _one_ die you roll for damage to a [6]. You can only use this ability once per combat.
      if ability['name'] == 'Dominate'
        character['roll'] = 6
      # Fearless (sp): Use this ability to raise your _speed_ by 2 for one combat round. This ability can only be used once per combat.
      elsif ability['name'] == 'Fearless'
        character['current']['speed'] += 2
      # Savagery (mo): You may raise your _brawn_ or _magic_ score by 2 for one combat round. You can only use _savagery_ once per combat.
      elsif ability['name'] == 'Savagery'
        if character['magic'] > character['brawn']
          character['magic'] += 2
        else
          character['brawn'] += 2
        end
      end
      #################
      # End Abilities #
      #################

      # Only once an Ability gets used is the (combat) history updated.
      @history << {
        'ability_id'   => ability['id'],
        'character_id' => character['id'],
        'round'        => @round
      }
    end
  end
end
