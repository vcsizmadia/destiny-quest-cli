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

end

# @author Vilmos Csizmadia
# @version 20170430
def get_character(number = nil, name = nil)
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
  if c = get_character(number, name)
    hp c['name']
    ap c
  else
    puts 'Unable to find the specified character.'.red
  end
end

@characters = [
  ########
  # Hero #
  ########
  {
    'name' => 'Hero',

    # Attributes
    'armour' => 0,
    'brawn'  => 0,
    'health' => 30,
    'magic'  => 0,
    'speed'  => 0,

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
    'special_abilities' => [
      # Nothing here but dust...
    ],

    # Statuses
    'statuses' => [
      # Nothing here but dust...
    ],

    # Paths (mage, rogue, or warrior) and careers
    'career' => nil,
    'path'   => nil,

    # Gold crowns ("money pouch")
    'gold' => 10
  },

  ###########
  # Serpent #
  ###########
  {
    'name' => 'Serpent',

    # Attributes
    'armour' => 0,
    'brawn'  => 0,
    'health' => 12,
    'magic'  => 0,
    'speed'  => 0,

    # Special abilities (combat, modifier, passive, speed)
    'special_abilities' => [
      'venom'
    ],

    # Statuses
    'statuses' => [
      # Nothing here but dust...
    ]
  }
]
