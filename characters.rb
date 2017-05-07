# def color_codes
#   {
#     :black   => 0, :light_black    => 60,
#     :red     => 1, :light_red      => 61,
#     :green   => 2, :light_green    => 62,
#     :yellow  => 3, :light_yellow   => 63,
#     :blue    => 4, :light_blue     => 64,
#     :magenta => 5, :light_magenta  => 65,
#     :cyan    => 6, :light_cyan     => 66,
#     :white   => 7, :light_white    => 67,
#     :default => 9
#   }
# end
# 
# #
# # Mode codes hash
# #
# def mode_codes
#   {
#     :default   => 0, # Turn off all attributes
#     :bold      => 1, # Set bold mode
#     :italic    => 3, # Set italic mode
#     :underline => 4, # Set underline mode
#     :blink     => 5, # Set blink mode
#     :swap      => 7, # Exchange foreground and background colors
#     :hide      => 8  # Hide text (foreground color would be the same as background)
#   }
# end

puts '... characters.rb'.light_black

class Character
  def initialize(hash = {})
    # This is basically the hero sheet.
    @data = {
      'id'   => nil,
      'name' => nil,

      # 'attributes' = {
        'armour' => 0,
        'brawn'  => 0,
        'health' => 0,
        'magic'  => 0,
        'speed'  => 0,
      # },

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

      # Backpack
      # No stacking; each item takes up exactly one space.
      'backpack' => [nil, nil, nil, nil, nil],

      # Special abilities (combat, modifier, passive, speed)
      'special_abilities' => {
        # Nothing here but dust...
      },

      # Statuses
      'statuses' => {},

      # Paths (mage, rogue, or warrior) and careers
      'career' => nil,
      'path'   => nil,

      # Gold crowns ("money pouch")
      'gold' => 0
    }

    @data.merge!(hash)
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

  def add(key, value)

  end

  # def data
  #   @data
  # end

  # def get(key)
  #   @data[key]
  # end

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
end

# @author Vilmos Csizmadia
# @version 20170430
def get_character(number = nil, name = nil)
  puts "... get_character(#{number.class.inspect}, #{name.inspect})".light_black

  if number && number.instance_of?(Integer)
    @characters[number - 1]
  elsif name && name.instance_of?(String)
    @characters.detect {|c| c['name'].downcase == name.downcase}
  end
end

# @author Vilmos Csizmadia
# @version 20170430
def list_characters
  @characters.each_with_index do |character, i|
    puts "#{i + 1}\t#{character['name']}"
    # ap character
  end
end

# @author Vilmos Csizmadia
# @version 20170430
def show_character(number = nil, name = nil)
  puts "... show_character(#{number.inspect}, #{name.inspect})".light_black

  if c = get_character(number, name)
    hp c['name']
    ap c
  else
    puts 'Unable to find the specified character.'.red
  end
end

#######################
#######################
## Character Library ##
#######################
#######################

# @characters = []

########
# Hero #
########
# c = Character.new({
#   'id'   => 1,
#   'name' => 'Hero'
# })
# c['attributes']['health'] = 30
# 
# @characters << c

@characters = [
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
    'special_abilities' => {
      # Fearless (sp): Use this ability to raise your _speed_ by 2 for one combat round. This ability can only be used once per combat.
      'fearless' => {'id' => 3, 'is_usable_once_per_combat' => true}
    },

    # Gold crowns ("money pouch")
    'gold' => 10
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
    'special_abilities' => {
      # Ferocity: If Mauler wins a combat round and inflicts health damage on your hero, the beast automatically raises its _speed_ to 7 for the next combat round.
      'ferocity' => {'id' => 2}
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
    'special_abilities' => {
      # Venom (pa): If your damage dice / damage score causes health damage to your opponent, they lose a further 2 _health_ at the end of every combat round, for the remainder of the combat. This ability ignores _armour_.
      'venom' => {'id' => 1}
    }
  })
]