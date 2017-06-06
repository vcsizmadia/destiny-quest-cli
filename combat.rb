puts '... combat.rb'.light_black

class Combat
  # @version 20170604
  def initialize(character_a, character_b)
    @a            = character_a
    @b            = character_b
    # Stores the list of used Character Abilities. Each combat should have a detailed history, and this is first step in that direction. Example:
    # [
    #   {
    #     character_ability_id: 3,
    #     round:                12
    #   },
    #   ...
    # ]
    @history      = []
    @is_post_roll = false
    # @phase   = 'start' # Keeps track of the current phase of the Combat, which influences the list of usable Abilities.
  end

  ####################
  # Instance Methods #
  ####################

  # This can be called at any time during combat to bring up the Ability selector. 
  # @param character [Character] the Characters for whom the ability selector is invoked
  # @param types [Array] the permitted types of Abilities for the selector
  # @version 20170604
  def ability_selector(character, types = [])
    is_active = true

    # Since multiple Abilities can be used at any time, do not exit the Ability selector until the necessary conditions are met.
    while is_active
      character_abilities = []

      # Determine which Abilities are (still) usable.
      character.character_abilities.each do |ca|
        a = ca.ability

        # [VC] We are going to have to modify the 'types' implementation, because the book is all over the place about this.
        if types.include?(a['type']) && is_character_ability_usable?(ca)
          character_abilities << ca
        end
      end

      puts @history.inspect.light_black
      puts character_abilities.inspect.light_black

      if character_abilities.any?
        puts 'Select an ability to use:'

        character_abilities.each do |ca|
          a = ca.ability

          puts "#{ca['id']}\t#{a['name']}\t(#{a['type']})\t#{stylize(a['description'])}"
        end

        input = gets.strip

        id = input.to_i

        if character_ability = character_abilities.detect {|ca| ca['id'] == id}
          ability = character_ability.ability

          # Ability is currently: ["fearless", {"id"=>3, "is_usable_once_per_combat"=>true, "name"=>"Fearless"}]
          # Needs to be: {"id"=>3, "is_usable_once_per_combat"=>true, "name"=>"Fearless"}
          puts 'POOP!'
          puts ability.inspect.yellow
          # ability = ability[1] # This is so ugly... we MUST refactor this mess...
          puts ability.inspect.green
          puts "You selected #{ability['name'].underline}.".light_black

          ###################
          # Begin Abilities #
          ###################
          case ability['name']

          # Charm (mo): You may re-roll one of your hero\'s die any time during a combat. You must accept the result of the second roll. If you have multiple items with the _charm_ ability, each one give you a re-roll.
          when 'Charm'
            character['roll'] = rand(6) + 1
            puts "... #{character['name'].underline} rerolled and got a [#{character['roll']}].".light_black
            # "You must accept the result of the second roll." Assuming no other die-related Abilities can be used after this...
            @is_post_roll = false

          # Dominate (mo): Change the result of _one_ die you roll for damage to a [6]. You can only use this ability once per combat.
          when 'Dominate'
            puts "... #{character['name'].underline} changed the [#{character['roll']}] to a [6].".light_black
            character['roll'] = 6
            # Assuming no other die-related Abilities can be used after this...
            @is_post_roll = false

          # Fearless (sp): Use this ability to raise your _speed_ by 2 for one combat round. This ability can only be used once per combat.
          when 'Fearless'
            character['current']['speed'] += 2
            puts "... +2 to (current) #{'speed'.underline}.".light_black

          # Savagery (mo): You may raise your _brawn_ or _magic_ score by 2 for one combat round. You can only use _savagery_ once per combat.
          when 'Savagery'
            if character['magic'] > character['brawn']
              character['magic'] += 2
              puts "... +2 to (current) #{'magic'.underline}.".light_black
            else
              character['brawn'] += 2
              puts "... +2 to (current) #{'brawn'.underline}.".light_black
            end
          end
          #################
          # End Abilities #
          #################

          # Only once an Ability gets used is the (combat) history updated.
          @history << {
            'character_ability_id' => character_ability['id'],
            'round'                => $round
          }
        end
      end

      # Exit the Ability selector if 1) there are no eligible Abilities to select from or 2) the User does not select any of the Abilities.
      is_active = false if character_abilities.none? || input == ''
    end

    # Even after roll, once the user is done with the Ability selector, set it so that we are no longer after a roll.
    @is_post_roll = false
  end

  # @version 20170604
  def fight
    $round   = 1

    # TODO: Break this down into different actions. We cannot just have a simple 'combat' method of course...
    while true
      loser  = nil
      winner = nil

      puts "\nRound #{$round}"

      ########
      # Hook #
      ########
      # Reset the current hash.

      ###########################
      # Initialize Combat Round #
      ###########################
      # TODO: Move this over to the Character model.
      # Idea: We may want to support 'current' systematically. It is that important to the architecture.
      [@a, @b].each do |c|
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
      [@a, @b].each do |c|
        # Ferocious: Per definition, the value of the 'ferocious' key must be '{'speed' => x}', where x is an integer.
        if c.has_fact?('is ferocious')
          c['current']['speed'] = c.get_fact('is ferocious')['speed']
          c.remove_fact('is ferocious')
          puts "Apply the effects of the 'is ferocious' fact to #{c['name']}.".light_black
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

      ability_selector(@a, ['sp']) # ['mo', 'sp']

      # TODO: These can all be performed on the Character level... or not? Hooks may alter this...
      numbers = [roll(@a, 'speed'), roll(@a, 'speed'), @a['current']['speed']]
      attack_speed_a = numbers.sum
      puts "... #{@a['name']} Attack Speed: #{numbers} => #{attack_speed_a}".light_black

      #####################
      # Character B Speed #
      #####################
      ability_selector(@b, ['sp'])

      numbers = [roll(@b, 'speed'), roll(@b, 'speed'), @b['current']['speed']]
      attack_speed_b = numbers.sum
      puts "... #{@b['name']} Attack Speed: #{numbers} => #{attack_speed_b}".light_black

      if attack_speed_a > attack_speed_b
        loser  = @b
        winner = @a
      elsif attack_speed_b > attack_speed_a
        loser  = @a
        winner = @b
      end

      ########
      # Hook #
      ########
      # Modifier (mo): Modifier abilities allow you to boost your attribute scores or influence dice that you aheva lready rolled.
      # You can use as many different modifier abilities as you wish during a combat round.
      # THIS WILL BE A PAIN IN THE ASS!

      if winner
        puts "... #{winner['name']} (#{winner['health']}) has a higher attack speed.".light_black

        # For now, only the winner gets to select an Ability.
        ability_selector(winner, ['mo'])

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

          # Check if the "loser" is still alive.
          if loser['health'] <= 0
            puts "... #{loser['name']} has been defeated."
            break
          end

          ##############################
          # Hook: Winner damages loser #
          ##############################
          # Charged
          if loser.has_ability_by_name?('Charged')
            winner['health'] -= 2
            puts "#{winner['name']} takes 2 damage due to #{loser['name']}'s '#{Ability.find(7)['name']}' special ability!".light_black
          end

          # Charm
          # if winner.has_ability_by_name?('Charm')
          #   roll = rand(6) + 1
          # end

          # Ferocity
          if winner.has_ability_by_name?('Ferocity')
            winner['statuses']['ferocious'] = {'speed' => 7} # , 'turns' => 1
            puts "#{winner['name']} is ferocious!".light_black
          end

          # Punishing blows
          if winner.has_ability_by_name?('Punishing blows') && loser['armour'] >= 1
            loser['armour'] -= 1 
            puts "#{loser['name']} loses 1 'armour' due to the 'Punishing blows' ability.".light_black
          end

          # Venom
          if winner.has_ability_by_name?('Venom')
            loser.add_fact('is poisoned')
          end

          # Check if the "winner" is still alive.
          if winner['health'] <= 0
            puts "... #{winner['name']} has been defeated."
            break
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
      # Fiery aura
      a = Ability.find_by_name('Fiery aura')

      if @a.has_ability?(a)
        @b['health'] -= 3
        puts "#{@b['name']} takes 3 damage due to #{@a['name']}'s '#{a['name']}' ability!".light_black
      end

      if @b.has_ability?(a)
        @a['health'] -= 3
        puts "#{@a['name']} takes 3 damage due to #{@b['name']}'s '#{a['name']}' ability!".light_black
      end

      [@a, @b].each do |c|
        # Venom / 'is poisoned'
        if c.has_fact?('is poisoned')
          c['health'] -= 2
          puts "... #{c['name']} takes 2 damage due to being poisoned."

          # [VC] Do we need to check this here right away? My guess is yes to prevent the affects of a defeated character's abilities. But then in what order should we check these abilities?
          # if c['health'] <= 0
          #   puts "... #{c['name']} has been defeated."
          #   break
          # end
        end

        # [VC] We should create a hook for health management. We should not have to keep checking Character health each time something happens.
        # Check if the Character is still alive.
        if c['health'] <= 0
          puts "... #{c['name']} has been defeated."
          break
        end
      end

      $round += 1
    end
  end

  # @param character_ability [CharacterAbility]
  # @param is_post_roll [Boolean]
  # @version 20170605
  def is_character_ability_usable?(character_ability)
    ability   = character_ability.ability
    is_usable = true

    # If the Ability can only be used after a roll...
    if ability['is_usable_only_after_a_roll']
      is_usable = @is_post_roll == true
    end

    # [VC] We should be able to merge the two loops below!

    # If the Ability can only be used once per combat...
    if ability['is_usable_once_per_combat']
      @history.each do |h|
        ca = CharacterAbility.find(h['character_ability_id'])

        # If the Ability has already been used...
        if ca['character_id'] == character_ability['character_id'] && ca['ability_id'] == ability['id']
          is_usable = false
          break
        end
      end
    end

    # If the Ability can only be used once per item...
    if ability['is_usable_once_per_item']
      @history.each do |h|
        ca = CharacterAbility.find(h['character_ability_id'])

        # If the Ability has already been used...
        if ca['character_id'] == character_ability['character_id'] && ca['ability_id'] == ability['id'] && ca['item_id'] == character_ability['item_id']
          is_usable = false
          break
        end
      end
    end

    is_usable
  end

  # @version 20170604
  # def phase
  #   @phase
  # end

  # @version 20170604
  # def phases
  #   [
  #     'start' #,
  #     # 'pre-roll'
  #   ]
  # end

  # This is a flexible method for rolling a die and potentially influencing it with Abilities.
  # @version 20170604
  def roll(character, purpose = nil)
    character['roll'] = rand(6) + 1

    ########
    # Hook #
    ########
    puts "... #{character['name'].underline} rolled a [#{character['roll']}] for #{purpose.underline}.".light_black

    # [VC] Let's assume the Ability selector
    # A roll for damage may be modified with an available 'mo' Ability:
    # if purpose == 'damage'
      # We just rolled a die, which is something we need to keep track of for the Ability selector.
      @is_post_roll = true
      ability_selector(character, ['mo'])
    # end

    character['roll']
  end
end
