puts '... characters.rb'.light_black

class Character
  def initialize(hash = {})
    # This is basically the hero sheet.
    @data = {
      'id'   => nil,
      'roll' => 0, # Can be modified by Abilities (such as 'Dominate').
      'name' => nil,

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
      'ring 1'    => nil,
      'ring 2'    => nil,
      'talisman'  => nil,

      # Backpack... irrelevant for now...
      # No stacking; each item takes up exactly one space.
      # 'backpack' => [nil, nil, nil, nil, nil],

      # Special abilities (combat, modifier, passive, speed)
      'ability_ids' => [],
      'special_abilities' => {
        # Nothing here but dust...
      },

      # Statuses
      'statuses' => {},

      # Paths (mage, rogue, or warrior) and careers... irrelevant for now...
      # 'career' => nil,
      # 'path'   => nil,

      # Gold crowns ("money pouch")
      'gold' => 0
    }

    @data.merge!(hash)
  end

  #################
  # Class Methods #
  #################

  def self.attributes
    [
      'armour',
      'brawn',
      'health',
      'magic',
      'speed'
    ]
  end

  # @author Vilmos Csizmadia
  # @version 20170522
  def self.find(id)
    $characters.detect {|c| c['id'] == id}
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

  # @author Vilmos Csizmadia
  # @version 20170518
  def abilities
    list = []

    self['ability_ids'].each do |id|
      if a = Ability.find(id)
        list << a
      end
    end

    list
  end

  # @author Vilmos Csizmadia
  # @version 20170519
  def data
    @data
  end

  # @author Vilmos Csizmadia
  # @version 20170521
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
      # If equipping this Item adds an Ability...
      if item['ability_id'] && ability = Ability.find(item['ability_id'])
        self['ability_ids'] << ability['id']
        puts "... Gained the '#{ability['name']}' ability.".light_black
      end

      self[equipment] = item['id']

      puts "... #{self['name']} has successfully equipped '#{item['name']}'.".light_black
    else
      puts "... '#{self['name']}' is unable to equip '#{equipment}' items.".red
    end
  end

  # def get(key)
  #   @data[key]
  # end

  # @author Vilmos Csizmadia
  # @version 20170515
  def has_ability_by_id?(ability_id)
    @data['ability_ids'].include?(ability_id)
  end

  def include?(key, value)
    @data[key].include?(value)
  end

  def merge(hash = {})
    @data.merge!(hash)
  end

  def remove(key, value)

  end

  # def set(key, value)
  #   @data[key] = value
  # end

  # @author Vilmos Csizmadia
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
            puts "...... -#{value} to '#{a}'.".light_black
          end
        end

        ###########
        # Ability #
        ###########
        # If unequipping this Item removes an Ability...
        if item['ability_id'] && index = self['ability_ids'].index(item['ability_id'])
          ability = Ability.find(item['ability_id'])

          self['ability_ids'].delete_at(index)

          puts "...... Lost the '#{ability['name']}' ability.".light_black
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
end

#######################
#######################
## Character Library ##
#######################
#######################

# The highest ID is currently 6.

# $characters = []

########
# Hero #
########
# c = Character.new({
#   'id'   => 1,
#   'name' => 'Hero'
# })
# c['attributes']['health'] = 30
# 
# $characters << c

$characters = [
  ########
  # Hero #
  ########
  Character.new({
    'id'   => 1,
    'name' => 'Hero',

    # Attributes
    'health' => 30,
    # 'speed'  => 8,

    # Special abilities (combat, modifier, passive, speed)
    'ability_ids' => [
      5, # Dominate
      3, # Fearless
      4  # Savagery
    ],
    'special_abilities' => {
      # Dominate (mo): Change the result of _one_ die you roll for damage to a [6]. You can only use this ability once per combat.
      'dominate' => {
        'id'                        => 5,
        'is_usable_once_per_combat' => true,
        'name'                      => 'Dominate',
        'type'                      => 'mo'
      },
      # Fearless (sp): Use this ability to raise your _speed_ by 2 for one combat round. This ability can only be used once per combat.
      'fearless' => {
        'id'                        => 3,
        'is_usable_once_per_combat' => true,
        'name'                      => 'Fearless',
        'type'                      => 'sp'
      },
      # Savagery (mo): You may raise your _brawn_ or _magic_ score by 2 for one combat round. You can only use _savagery_ once per combat.
      'savagery' => {
        'id'                        => 4,
        'is_usable_once_per_combat' => true,
        'name'                      => 'Savagery',
        'type'                      => 'mo'
      },
    },

    # Gold crowns ("money pouch")
    'gold' => 10
  }),

  #############
  # Humbaroth #
  #############
  # "Humbaroth the giant"
  Character.new({
    'id'   => 4,
    'name' => 'Humbaroth',

    # Attributes
    'armour' => 4,
    'brawn'  => 9,
    'health' => 35,
    'speed'  => 4,

    # Special abilities (combat, modifier, passive, speed)
    'ability_ids' => [
      6 # Punishing blows
    ]
  }),

  ###################
  # Malachi of fire #
  ###################
  # "Humbaroth the giant"
  Character.new({
    'id'   => 6,
    'name' => 'Malachi of fire',

    # Attributes
    'armour' => 2,
    'health' => 20,
    'magic'  => 4,
    'speed'  => 4,

    # Special abilities (combat, modifier, passive, speed)
    'ability_ids' => [
      8 # Fiery aura
    ]
  }),

  ##########
  # Mauler #
  ##########
  Character.new({
    'id'   => 2,
    'name' => 'Mauler',

    # Attributes
    'armour' => 5,
    'brawn'  => 8,
    'health' => 30,
    'speed'  => 5,

    # Special abilities (combat, modifier, passive, speed)
    'ability_ids' => [
      2 # Ferocity
    ],
    # DEPRECATED:
    'special_abilities' => {
      # Ferocity: If Mauler wins a combat round and inflicts health damage on your hero, the beast automatically raises its _speed_ to 7 for the next combat round.
      'ferocity' => {
        'id'   => 2,
        'name' => 'Ferocity'
      }
    }
  }),

  ###########
  # Serpent #
  ###########
  Character.new({
    'id'   => 3,
    'name' => 'Serpent',

    # Attributes
    'health' => 12,

    # Special abilities (combat, modifier, passive, speed)
    'ability_ids' => [
      1 # Venom
    ],
    'special_abilities' => {
      # Venom (pa): If your damage dice / damage score causes health damage to your opponent, they lose a further 2 _health_ at the end of every combat round, for the remainder of the combat. This ability ignores _armour_.
      'venom' => {
        'id'   => 1,
        'name' => 'Venom'
      }
    }
  }),

  ###################
  # Storm elemental #
  ###################
  Character.new({
    'id'   => 5,
    'name' => 'Storm elemental',

    # Attributes
    'armour' => 1,
    'health' => 25,
    'magic'  => 1,
    'speed'  => 2,

    # Special abilities (combat, modifier, passive, speed)
    'ability_ids' => [
      7 # Charged
    ]
  })
]
