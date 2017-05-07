require 'awesome_print' # 'awesome_print' gem, required for using 'ap'
require 'colorize'      # 'colorize' gem, required for using '.red', '.yellow', etc.
require 'pp'

puts "\nLoading...".light_black

require './abilities.rb'
require './characters.rb'
require './items.rb'
require './methods.rb'

###################
# Challenge Tests #
###################
# is_success = roll + roll + character['<name of attribute being tested>'] >= <value of attribute treshold>

@hero    = @characters[0]
@serpent = @characters[1]

puts 'The primary goal of DestinyQuest is to equip your hero with better weapons, armour and equipment.'

hp 'Commands'
puts '- c    ... Shows a specific character.'
puts '- c *  ... Lists all the characters.'
puts '- l i  ... Lists the items.'
puts '- f    ... Initiates combat.'
puts '- e    ... Equips item.'
puts '- r    ... Removes item in the specified equipment slot.'
puts '- x    ... Exits.'

# puts '- reset ... Resets the characters'

input = ''

while input != 'x'
  print ': '
  input = gets.strip # Remove all the crap.

  case input
  ##################
  # Show Character #
  ##################
  when 'c'
    puts 'Which character?'
    identifier = gets.strip

    if identifier.to_i > 0
      show_character(identifier.to_i, nil)
    else
      show_character(nil, identifier)
    end
  ###################
  # List Characters #
  ###################
  when 'c *'
    list_characters
  #########
  # Equip #
  #########
  when 'e'
    puts 'Equip what?'
    item_name = gets.strip
    equip_item(@hero, item_name)
  #########
  # Fight #
  #########
  when 'f'
    combat(@characters[0], @characters[1])
  #############
  # Show Item #
  #############
  when 'i'
    puts 'Which item?'
    identifier = gets.strip

    if identifier.to_i > 0
      show_item(identifier.to_i, nil)
    else
      show_item(nil, identifier)
    end
  ##############
  # List Items #
  ##############
  when 'l i'
    list_items
  ##########
  # Remove #
  ##########
  when 'r'
    puts 'Remove which equipment?'
    equipment_name = gets.strip
    remove_item(@hero, equipment_name)
  end
end

# DEFEAT IS NOT THE END! Simply return to the map and try again. While 'health' will be fully restored, consumable items used in combat remain lost.
