puts '... combat.rb'.light_black

class Combat
  # @version 20170604
  def initialize(character_a, character_b)
    ########
    # Note #
    ########
    # The 'history' Array stores the list of used Character Abilities. Each combat should have a detailed history, and this is first step in that direction. Example:
    # [
    #   {
    #     character_ability_id: 3,
    #     round:                12
    #   },
    #   ...
    # ]
    @a                     = character_a
    @b                     = character_b
    @damage_score_modifier = 0 # This is often affected by (co) Abilities.
    @history               = []
    @loser                 = nil
    @round                 = 1
    @winner                = nil

    # TRYING SOMETHING NEW HERE... FOR MANIPULATING THE ACTIVITY SELECTOR!!!
    @current_character = nil # @a || @b
    @current_step      = nil # 'attack speed' || 'damage score' || 'passive effects'
    @current_substep   = nil # 'pre-roll' || 'post-roll'
    @other_character   = nil # @b || @a
  end

  ####################
  # Instance Methods #
  ####################

  # The Ability selector can be called at any time during combat for a specific Character.
  # @param character [Character] the Characters for whom the Ability selector is invoked
  # @version 20170613
  def ability_selector(character)
    is_active       = true
    other_character = character == @a ? @b : @a

    # Since multiple Abilities can be used at any time, do not exit the Ability selector until the necessary conditions are met.
    while is_active
      character_abilities = []

      # Determine which Abilities are (still) usable.
      character.character_abilities.each do |ca|
        character_abilities << ca if is_character_ability_usable?(ca)
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

          # Ability is currently: ["fearless", {"id"=>3, "is_only_usable_once_per_combat"=>true, "name"=>"Fearless"}]
          # Needs to be: {"id"=>3, "is_only_usable_once_per_combat"=>true, "name"=>"Fearless"}
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
            set_current(@current_character, @current_step, nil)

          # Chill touch (sp): Use this ability to reduce your opponent's _speed_ by 2 for one combat round. You can only use _chill touch_ once per combat.
          when 'Chill touch'
            other_character['current']['speed'] -= 2
            puts "... -2 to (current) #{'speed'.underline} of #{other_character['name'].underline}.".light_black

          # Dominate (mo): Change the result of _one_ die you roll for damage to a [6]. You can only use this ability once per combat.
          when 'Dominate'
            puts "... #{character['name'].underline} changed the [#{character['roll']}] to a [6].".light_black
            character['roll'] = 6
            # Assuming no other die-related Abilities can be used after this...
            set_current(@current_character, @current_step, nil)

          # Fearless (sp): Use this ability to raise your _speed_ by 2 for one combat round. This ability can only be used once per combat.
          when 'Fearless'
            character['current']['speed'] += 2
            puts "... +2 to (current) #{'speed'.underline}.".light_black

          # First cut (pa): This ability allows you to inflict 1 _health_ damage to your opponent before combat begins. This ability ignores _armour_. (This ability cannot be used by assassins.)
          when 'First cut'
            other_character['health'] -= 1
            puts "... -1 to #{'health'.underline} of #{other_character['name'].underline}.".light_black

          # Might of stone (mo): You may instantly increase your _armour_ score by 3 for one combat round. You can only use this ability once per combat.
          when 'Might of stone'
            character['current']['armour'] += 3
            puts "... +3 to (current) #{'armour'.underline}.".light_black

          # Pound (co): A mighty blow that increases your damage score by 3. However, in the next combat round, you must lower your _speed_ by 1. This ability can only be used once per combat.
          when 'Pound'
            @damage_score_modifier += 3
            character.add_fact('is recovering from pound')
            puts "... +3 to damage score.".light_black

          # Savagery (mo): You may raise your _brawn_ or _magic_ score by 2 for one combat round. You can only use _savagery_ once per combat.
          when 'Savagery'
            if character['magic'] > character['brawn']
              character['magic'] += 2
              puts "... +2 to (current) #{'magic'.underline}.".light_black
            else
              character['brawn'] += 2
              puts "... +2 to (current) #{'brawn'.underline}.".light_black
            end

          # Slam (co): Use this ability to stop your opponent rolling for damage when they have won a round. In the next combat round, your opponent's _speed_ is reduced by 1. You can only use this ability once per combat.
          when 'Slam'
            other_character['is_roll_stopped'] = true
            other_character.add_fact('is slammed')
          end
          #################
          # End Abilities #
          #################

          # Only once an Ability gets used is the (combat) history updated.
          @history << {
            'character_ability_id' => character_ability['id'],
            'round'                => @round
          }
        end
      end

      # Exit the Ability selector if 1) there are no eligible Abilities to select from or 2) the User does not select any of the Abilities.
      is_active = false if character_abilities.none? || input == ''
    end
  end

  # @version 20170613
  def fight
    #########
    # Notes #
    #########
    # Each round of combat consists of the following steps and substeps. Abilities are available for use based on the step and substep combinations.
    #
    # Order  Step             Substep    Character  Notes
    # -----  ----             -------    ---------  -----
    # 1      attack speed     pre-roll   a
    # 2      attack speed     post-roll  a
    # 3      attack speed     pre-roll   b
    # 4      attack speed     post-roll  b
    #
    # At this point in time, both the loser and the winner are determined.
    #
    # 5      damage score     pre-roll   winner
    # 6      damage score     post-roll  winner
    # 7      passive effects             a
    # 8      passive effects             b
    @round = 1

    #################
    # Before combat #
    #################
    [@a, @b].each do |c|
      set_current(c, nil, nil)

      ability_selector(c)
    end

    # TODO: Break this down into different actions. We cannot just have a simple 'combat' method of course...
    while true
      @damage_score_modifier = 0
      @loser                 = nil
      @winner                = nil

      # hp "Round #{@round}"
      puts "\nRound #{@round}"

      ###########################
      # Initialize Combat Round #
      ###########################
      # TODO: Move this over to the Character model.
      # Idea: We may want to support 'current' systematically. It is that important to the architecture.
      [@a, @b].each do |c|
        c['current'] = {}
        c['current']['armour']       = c['armour'] # Used by the 'Might of stone' Ability.
        c['current']['attack speed'] = 0           # Reset this!
        c['current']['speed']        = c['speed']  # Used by the 'Ferocity' Ability.
      end

      ########
      # Hook #
      ########
      # TODO: Move this over to the Character model.
      # TODO: Name all of these different hooks...
      # Immediately apply certain modifiers.
      [@a, @b].each do |c|
        other_character = c == @a ? @b : @a

        # check_and_apply_is_ferocious(c)
        # Ferocious: Per definition, the value of the 'ferocious' key must be '{'speed' => x}', where x is an integer.
        if c.has_fact?('is ferocious')
          c['current']['speed'] = c.get_fact('is ferocious')['speed']
          c.remove_fact('is ferocious')
          puts "Apply the effects of the 'is ferocious' fact to #{c['name']}.".light_black
        end

        # Is recovering from pound?
        if c.has_fact?('is recovering from pound')
          c['current']['speed'] -= 1 # [VC] TODO: It is currently possible to get -1... fix this!
          c.remove_fact('is recovering from pound')
          puts "Apply the effects of the 'is recovering from pound' fact to #{c['name']}.".light_black
        end

        # Is slammed?
        if c.has_fact?('is slammed')
          c['current']['speed'] -= 1
          c.remove_fact('is slammed')
          puts "Apply the effects of the 'is slammed' fact to #{c['name']}.".light_black
        end

        # [VC] TODO: There should be a better way to implement this...
        # Webbed: The spider's sticky webbing inhibits your movement. At the start of every combat round, roll a die. If you roll [1] or [2], then your _speed_ is reduced by 1 for that combat round. (Note: Ignore this ability if you have used your torch to set fire to the web.)
        if other_character.has_ability_by_name?('Webbed')
          c['roll'] = rand(6) + 1

          if [1, 2].include?(c['roll'])
            c['current']['speed'] -= 1 # if c['current']['speed'] >= 1
            puts "Applying the effects of the #{'Webbed'.underline} ability to #{c['name'].underline}...".light_black
            puts "... -1 to #{'speed'.underline} of #{c['name'].underline}.".light_black
          end
        end
      end

      ###########
      # Potions #
      ###########
      # You can only use one potion per combat round.

      ##################################
      # 1, 2, 3, and 4 - Attack Speeds #
      ##################################
      [@a, @b].each do |c|
        set_current(c, 'attack speed', nil)
        ability_selector(c)

        numbers = [roll, roll, c['current']['speed']]

        c['current']['attack speed'] = numbers.sum

        puts "... #{c['name']} Attack Speed: #{numbers} => #{c['current']['attack speed']}".light_black
      end

      # Determine the winner and the loser (if possible).
      if @a['current']['attack speed'] > @b['current']['attack speed']
        @loser  = @b
        @winner = @a
      elsif @b['current']['attack speed'] > @a['current']['attack speed']
        @loser  = @a
        @winner = @b
      end

      if @winner
        puts "... #{@winner['name']} (#{@winner['health']}) has a higher attack speed.".light_black

        ##########################
        # 5 and 6 - Damage Score #
        ##########################
        set_current(@winner, 'damage score', nil)
        # For now, only the winner gets to select an Ability. Actually, let us skip this for now, since rolling allows the character to immediately invoke the Ability selector.
        # ability_selector(@winner)

        numbers      = [roll, @damage_score_modifier, @winner['magic'] > @winner['brawn'] ? @winner['magic'] : @winner['brawn']]
        damage_score = numbers.sum

        # [VC] TODO: There should be a better way to implement this...
        # Piercing claws: The ghouls' attacks ignore _armour_.
        if @winner.has_ability_by_name?('Piercing claws')
          damage = damage_score
          puts "The 'Piercing claws' ability ignores #{'armor'.underline}.".light_black
        else
          damage = damage_score - @loser['current']['armour'] > 0 ? damage_score - @loser['current']['armour'] : 0    
          puts "... Loser: #{@loser['name'].underline} ... #{@loser['armour']} -> #{@loser['current']['armour']} #{'armour'.underline}".light_black
        end

        puts "... #{@winner['name']} Damage Score: #{numbers} => #{damage_score} => Damage: #{damage}".light_black

        # If the winner manages to do damage to the loser...
        if damage > 0
          # @loser['health'] = @loser['health'] - damage < 0 ? 0 : @loser['health'] - damage
          @loser['health'] -= damage

          puts "... #{@loser['name']} takes #{damage} points of health damage."

          # Check if the loser is still alive.
          if @loser['health'] <= 0
            puts "... #{@loser['name']} has been defeated."
            break
          end

          ###########################
          # Begin Passive Abilities #
          ###########################
          # Charged
          if @loser.has_ability_by_name?('Charged')
            @winner['health'] -= 2
            puts "#{@winner['name']} takes 2 damage due to #{@loser['name']}'s '#{Ability.find(7)['name']}' special ability!".light_black
          end

          # Charm
          # if @winner.has_ability_by_name?('Charm')
          #   roll = rand(6) + 1
          # end

          # Ferocity
          if @winner.has_ability_by_name?('Ferocity')
            @winner['statuses']['ferocious'] = {'speed' => 7} # , 'turns' => 1
            puts "#{@winner['name']} is ferocious!".light_black
          end

          # Punishing blows
          if @winner.has_ability_by_name?('Punishing blows') && @loser['armour'] >= 1
            @loser['armour'] -= 1 
            puts "#{@loser['name']} loses 1 'armour' due to the 'Punishing blows' ability.".light_black
          end

          # Venom
          if @winner.has_ability_by_name?('Venom')
            @loser.add_fact('is poisoned')
          end

          # Check if the winner is still alive.
          if @winner['health'] <= 0
            puts "... #{@winner['name']} has been defeated."
            break
          end
          #########################
          # End Passive Abilities #
          #########################
        end
      end

      #####
      # 7 #
      #####
      set_current(@a, 'passive effects', nil)

      #####
      # 8 #
      #####
      set_current(@b, 'passive effects', nil)

      # Reset it all...
      set_current(nil, nil, nil)






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
        other_character = c == @a ? @b : @a

        # Black sigils
        a = Ability.find_by_name('Black sigils')
        if c.has_ability?(a)
          other_character['health'] -= 1
          puts "#{other_character['name']} takes 1 damage due to #{c['name']}'s '#{a['name']}' ability!"
        end

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

        # [VC] TODO: Get this working against all Characters once such a thing is possible.
        # Thorns (pa): At the end of every combat round, you automatically inflict 1 damage to all of our opponents. This ability ignores _armour_.
        a = Ability.find_by_name('Thorns')
        if c.has_ability?(a)
          other_character['health'] -= 1
          puts "#{other_character['name'].underline} takes 1 damage due to #{c['name'].underline}'s #{a['name'].underline} ability!"
        end

        # FINISH THIS!!!
        # Warts and all
        a = Ability.find_by_name('Warts and all')
        if c.has_ability?(a)
          # other_character['health'] -= 1
          # puts "#{other_character['name'].underline} takes 1 damage due to #{c['name'].underline}'s #{a['name'].underline} ability!"
        end

        # [VC] We should create a hook for health management. We should not have to keep checking Character health each time something happens.
        # Check if the Character is still alive.
        if c['health'] <= 0
          puts "... #{c['name']} has been defeated."
          break
        end
      end

      @round += 1
    end
  end

  # @param character_ability [CharacterAbility]
  # @version 20170613
  def is_character_ability_usable?(character_ability)
    ability   = character_ability.ability
    is_usable = true

    # puts "... Is #{ability['name'].underline} usable?".light_black

    # Restriction: is_only_usable_against_winner
    if is_usable && ability['is_only_usable_against_winner']
      if @winner && character_ability['character_id'] == @winner['id']
        # puts '...... Unusable due to: is_only_usable_against_winner.'.light_black
        # puts "......... Winner Character ID:            #{@winner['id']}".light_black
        # puts "......... Character Ability Character ID: #{character_ability['character_id']}".light_black
        is_usable = false
      end
    end

    # Restriction: is_only_usable_before_combat
    if is_usable && ability['is_only_usable_before_combat']
      if @current_step != nil
        # puts '...... Unusable due to: is_only_usable_before_combat.'.light_black
        is_usable = false
      end
    end

    # Restriction: is_only_usable_for_attack_speed
    if is_usable && ability['is_only_usable_for_attack_speed']
      # is_usable = @current_step == 'attack speed'
      if @current_step != 'attack speed'
        # puts '...... Unusable due to: is_only_usable_for_attack_speed.'.light_black
        is_usable = false
      end
    end

    # Restriction: is_only_usable_for_damage_score
    if is_usable && ability['is_only_usable_for_damage_score']
      # is_usable = @current_step == 'damage score'
      if @current_step != 'damage score'
        # puts '...... Unusable due to: is_only_usable_for_damage_score.'.light_black
        is_usable = false
      end
    end

    # [VC] We should be able to merge the two loops below!

    # Restriction: is_only_usable_once_per_combat
    if is_usable && ability['is_only_usable_once_per_combat']
      @history.each do |h|
        ca = CharacterAbility.find(h['character_ability_id'])

        # If the Ability has already been used...
        if ca['character_id'] == character_ability['character_id'] && ca['ability_id'] == ability['id']
          # puts '...... Unusable due to: is_only_usable_once_per_combat.'.light_black
          is_usable = false
          break
        end
      end
    end

    # Restriction: is_only_usable_once_per_item
    if is_usable && ability['is_only_usable_once_per_item']
      @history.each do |h|
        ca = CharacterAbility.find(h['character_ability_id'])

        # If the Ability has already been used...
        if ca['character_id'] == character_ability['character_id'] && ca['ability_id'] == ability['id'] && ca['item_id'] == character_ability['item_id']
          # puts '...... Unusable due to: is_only_usable_once_per_item.'.light_black
          is_usable = false
          break
        end
      end
    end

    # Restriction: is_only_usable_post_roll
    if is_usable && ability['is_only_usable_post_roll']
      # is_usable = @current_substep == 'post-roll'
      if @current_substep != 'post-roll'
        # puts '...... Unusable due to: is_only_usable_post_roll.'.light_black
        is_usable = false
      end
    end

    # Restriction: is_only_usable_pre_roll
    if is_usable && ability['is_only_usable_pre_roll']
      # is_usable = @current_substep == 'pre-roll'
      if @current_substep != 'pre-roll'
        # puts '...... Unusable due to: is_only_usable_pre_roll.'.light_black
        is_usable = false
      end
    end

    # Restriction: is_passive
    if is_usable && ability['is_passive']
      # puts '...... Unusable due to: is_passive.'.light_black
      is_usable = false
    end

    is_usable
  end

  # [VC] We may want to rename this at some point to 'attempt_roll' or 'try_roll' or something like that, because it may be not even happen. For example, the other Character may stop it with an Ability.

  # This is a flexible method for rolling a die and potentially influencing it with Abilities.
  ########### @param character [Character]
  ########### @param purpose [String] optional
  # @return [Integer] 0 (if the roll is stopped), 1, 2, 3, 4, 5, or 6
  # @version 20170613
  def roll # (character, purpose = nil)
    # This will get tricky once a Character is fighting multiple Characters.
    @current_character['is_roll_stopped'] = false
    @current_character['roll']            = 0
    # other_character              = character == @a ? @b : @a

    set_current(@current_character, @current_step, 'pre-roll')

    # Give the other Character the opportunity to screw things up.
    ability_selector(@current_character)
    ability_selector(@other_character)

    # Unless the roll is stopped by an Ability.
    unless @current_character['is_roll_stopped']
      @current_character['roll'] = rand(6) + 1

      ########
      # Hook #
      ########
      # puts "... #{@current_character['name'].underline} rolled a [#{@current_character['roll']}] for #{purpose.underline}.".light_black
      puts "... #{@current_character['name'].underline} rolled a [#{@current_character['roll']}].".light_black

      # [VC] We should have a better, attributes-driven solution for this. How about something like:
      # - is_automatic             = true # Same as passive?
      # - is_only_usable_post_roll = true
      # - is_passive               = true

      # Bewitched: Re-roll any [1] or [2] dice results for Zalladell. The results of the re-rolled dice must be used.
      a = Ability.find_by_name('Bewitched')
      if @current_character.has_ability?(a)
        if [1, 2].include?(@current_character['roll'])
          @current_character['roll'] = rand(6) + 1
          puts "#{@current_character['name']} re-rolled due to the #{a['name'].underline} ability and got a [#{@current_character['roll']}]!".light_black
        end
      end

      # We just rolled a die, which is something we need to keep track of for the Ability selector.
      set_current(@current_character, @current_step, 'post-roll')

      # Crone's dagger: If the ruffians roll a [6] for damage, the crone's dagger automatically inflicts an extra point of _health_ damage.
      a = Ability.find_by_name('Crone\'s dagger')
      if @current_step == 'damage score' && @current_character.has_ability?(a)
        if @current_character['roll'] == 6
          @damage_score_modifier += 1
          puts "#{@current_character['name']} rolled a [6] and therefore automatically inflicts an extra point of #{'health'.underline} damage due to the #{a['name'].underline} ability!".light_black
        end
      end

      ability_selector(@current_character)
      ability_selector(@other_character)
    end

    # In case an Ability has not already done this...
    set_current(@current_character, @current_step, nil)

    @current_character['roll']
  end

  # @version 20170609
  def set_current(character, step, substep)
    @current_character = character
    @current_step      = step
    @current_substep   = substep

    if @current_character
      @other_character = @current_character == @a ? @b : @a
    else
      @other_character = nil
    end

    puts "\nStep: #{@current_character ? @current_character['name'] : 'nil'} ... #{@other_character ? @other_character['name'] : 'nil'} ... #{@current_step ? @current_step : 'nil'} ... #{@current_substep ? @current_substep : 'nil'}".light_black
  end
end
