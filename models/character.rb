puts '... ./models/character.rb'.light_black

class Character
  # @version 20170604
  def initialize(hash = {})
    # This is basically the hero sheet.
    @data = {
      'id'       => nil,
      'name'     => nil,

      # Combat
      'is_roll_stopped' => false,
      'roll'            => 0, # Can be modified by Abilities (such as 'Dominate').

      # Attributes
      'armour' => 0,
      'brawn'  => 0,
      'health' => 0,
      'magic'  => 0,
      'speed'  => 0,

      # Used for temporary attribute changes during combat.
      # 'overrides' => [],
      'current' => {},

      # Equipment
      # Replacing an equipped item destroys that item.
      'chest'     => nil,
      'cloak'     => nil,
      'feet'      => nil,
      'head'      => nil,
      'gloves'    => nil,
      'left hand' => nil,
      'main hand' => nil,
      'necklace'  => nil,
      'ring'      => nil,
      # 'ring 1'  => nil,
      # 'ring 2'  => nil,
      'talisman'  => nil,

      # Backpack... irrelevant for now...
      # No stacking; each item takes up exactly one space.
      # 'backpack' => [nil, nil, nil, nil, nil],

      # Facts
      'facts'      => {},
      'immunities' => [], # Example: [{ability_id: 1, immunity: 'is poisoned'}, ...]

      # Paths (mage, rogue, or warrior) and careers... irrelevant for now...
      # 'career' => nil,
      # 'path'   => nil,

      # Gold crowns ("money pouch")
      'gold' => 0
    }

    @data.merge!(hash)
  end

  ################
  # Associations #
  ################

  # @version 20170530
  def character_abilities
    $character_abilities.select {|ca| ca['character_id'] == self['id']}
  end

  #################
  # Class Methods #
  #################

  # @version 20170526
  def self.add(hash)
    c = Character.new({
      'id' => $characters.length + 1
    }.merge!(hash))

    $characters << c

    c
  end

  def self.attributes
    [
      'armour',
      'brawn',
      'health',
      'magic',
      'speed'
    ]
  end

  def self.equipment_names
    [
      'chest',
      'cloak',
      'feet',
      'head',
      'gloves',
      'left hand',
      'main hand',
      'necklace',
      'ring 1',
      'ring 2',
      'talisman'
    ]
  end

  # @version 20170522
  def self.find(id)
    $characters.detect {|c| c['id'] == id}
  end

  # @version 20170621
  def self.find_by_name(name)
    $characters.detect {|c| c['name'] == name}
  end

  ####################
  # Instance Methods #
  ####################

  def [](key)
    @data[key]
  end

  def []=(key, value)
    @data[key] = value
  end

  # @version 20170623
  def add_ability(ability)
    CharacterAbility.create(self, ability, nil)

    # Add immunities (if applicable).
    ability['immunities'].each do |i|
      self['immunities'] << {
        'ability_id' => ability['id'],
        'immunity'   => i
      }

      puts "... #{self['name'].underline} gained immunity to #{i.underline}.".light_black
    end
  end

  # @param fact [String] the phrase representing the fact
  # @param details [Hash] attributes or other details we need to keep track of for the fact
  # @version 20170623
  def add_fact(fact, details = {})
    if self.has_immunity?(fact)
      puts "...... #{self['name'].underline} is immune to #{fact.underline}..."
    elsif !self['facts'].has_key?(fact)
      self['facts'][fact] = details
      puts "...... #{self['name'].underline} #{fact.underline}!"
    end
  end

  # @version 20170601
  def add_item_ability(item, ability)
    CharacterAbility.create(self, ability, item)
  end

  # @version 20170519
  def data
    @data
  end

  # @version 20170601
  def equip(item)
    equipment = item['equipment']

    puts "\n'#{self['name']}' is attempting to equip the '#{equipment}' item '#{item['name']}'...".light_black

    if self.data.has_key?(equipment)
      self.unequip(equipment) if self[equipment]

      ##############
      # Attributes #
      ##############
      Character.attributes.each do |a|
        # If equipping this Item modifies the attribute...
        if value = item[a]
          self[a] += value
          puts "... +#{value} to #{a.underline}.".light_black
        end
      end

      ###########
      # Ability #
      ###########
      if a = item.ability
        self.add_item_ability(item, a)
        puts "... Gained the #{a['name'].underline} ability.".light_black
      end

      self[equipment] = item['id']

      puts "... #{self['name']} has successfully equipped '#{item['name']}'.".light_black
    else
      puts "... '#{self['name']}' is unable to equip '#{equipment}' items.".red
    end
  end

  # @version 20170602
  def get_fact?(fact)
    self['facts'][fact]
  end

  # @version 20170603
  def has_ability?(ability)
    !!self.character_abilities.detect {|ca| ca['ability_id'] == ability['id']}
  end

  # @version 20170602
  def has_ability_by_id?(ability_id)
    !!self.character_abilities.detect {|ca| ca['ability_id'] == ability_id}
  end

  # @version 20170602
  def has_ability_by_name?(name)
    !!self.character_abilities.detect {|ca| ca.ability['name'] == name}
  end

  # @version 20170602
  def has_fact?(fact)
    self['facts'].has_key?(fact)
  end

  # @version 20170623
  def has_immunity?(immunity)
    !!self['immunities'].detect {|i| i['immunity'] == immunity}
  end

  # @version 20170521
  def unequip(equipment)
    puts "... '#{self['name']}' is attempting to unequip the '#{equipment}' item...".light_black

    if self.data.has_key?(equipment)
      if item = Item.find(self[equipment])
        puts "...... Found '#{item['name']}'.".light_black

        ##############
        # Attributes #
        ##############
        Character.attributes.each do |a|
          # If unequipping this Item modifies the attribute...
          if value = item[a]
            self[a] -= value
            puts "...... -#{value} to #{a.underline}.".light_black
          end
        end

        ###########
        # Ability #
        ###########
        # If a Character Ability was created when this Item was equipped...
        # if item['ability_id'] && index = self['ability_ids'].index(item['ability_id'])
        if ca = self.character_abilities.detect {|ca| ca['item_id'] == item['id']}
          a = ca.ability

          ca.destroy

          puts "...... Lost the #{a['name'].underline} ability.".light_black
        end

        puts "...... #{self['name']} has successfully unequipped '#{item['name']}'.".light_black
      else
        puts "... '#{self['name']}' does not have anything equipped in '#{equipment}'.".light_black
      end

      self[equipment] = nil
    else
      puts "... '#{self['name']}' is unable to equip '#{equipment}' items.".red
    end
  end

  # @version 20170602
  def remove_fact(fact)
    self['facts'].delete(fact)
  end
end
