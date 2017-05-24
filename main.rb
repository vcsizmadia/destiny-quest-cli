require 'awesome_print' # 'awesome_print' gem, required for using 'ap'
require 'colorize'      # 'colorize' gem, required for using '.red', '.yellow', '.underline', etc.
require 'ap'
require 'pp'

################
# AwesomePrint #
################
AwesomePrint.defaults = {
  :indent => -2,
  sort_keys: true,
  :color => {
    :args       => :yellowish,
    :array      => :blue,
    :bigdecimal => :blue,
    :class      => :yellow,
    :date       => :greenish,
    :falseclass => :red,
    :fixnum     => :blue,
    :float      => :blue,
    :hash       => :cyanish,
    :keyword    => :cyan,
    :method     => :purpleish,
    :nilclass   => :red,
    :rational   => :blue,
    :string     => :yellowish,
    :struct     => :pale,
    :symbol     => :cyanish,
    :time       => :greenish,
    :trueclass  => :green,
    :variable   => :cyanish
  }
}

############
# Colorize #
############
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

puts "\nLoading...".light_black

require './abilities.rb'
require './characters.rb'
require './items.rb'
require './methods.rb'

###################
# Challenge Tests #
###################
# is_success = roll + roll + character['<name of attribute being tested>'] >= <value of attribute treshold>

####################
# Global Variables #
####################
$hero    = $characters[0] # Temporary...
# Stores the list of Abilities used by Characters. Each combat should have detailed history, and this is first step in that direction. Example:
# [
#   {
#     ability_id: 3,
#     character_id: 1,
#     round: 12
#   },
#   ...
# ]
$history = []
$round   = 1
$serpent = $characters[1] # Temporary...

puts 'The primary goal of DestinyQuest is to equip your hero with better weapons, armour and equipment.'

hp 'Commands'
puts '- a    ... Shows a specific ability.'
puts '- a *  ... Lists all the abilities.'
puts '- c    ... Show a specific character (or list them all).'
puts '- i    ... Show a specific item (or list them all).'
puts '- f    ... Initiates combat.'
puts '- e    ... Equips item.'
puts '- r    ... Removes item in the specified equipment slot.'
puts '- x    ... Exits.'

input = ''

while input != 'x'
  print ': '
  input = gets.strip

  case input
  ################
  # Show Ability #
  ################
  when 'a'
    puts 'Enter the ID of the ability:'
    id = gets.strip.to_i

    show_ability(id) if id > 0

  ##################
  # List Abilities #
  ##################
  when 'a *'
    list_abilities

  ##############
  # Characters #
  ##############
  when 'c'
    puts 'Enter the ID of the character (or \'*\' to list them all):'
    input = gets.strip

    if input == '*'
      $characters.each {|c| puts "#{c['id']}\t#{c['name']}"}
      # $characters.each_with_index do |character, i|
      #   puts "#{i + 1}\t#{character['name']}"
      # end
    elsif c = Character.find(input.to_i)
      hp c['name']
      ap c.data
    else
      puts 'Unable to find the specified character.'.red
    end

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
    puts 'Enter the ID of the item you wish to equip:'
    id = gets.strip.to_i

    if item = Item.find(id)
      $hero.equip(item)
    end

  #########
  # Fight #
  #########
  when 'f'
    combat(Character.find(1), Character.find(6))

  #########
  # Items #
  #########
  when 'i'
    puts 'Enter the ID of the item (or \'*\' to list them all):'
    input = gets.strip

    if input == '*'
      $items.each {|i| puts "#{i['id']}\t#{i['name']}\t#{i['equipment']}"}
    elsif i = Item.find(input.to_i)
      hp i['name']
      ap i.data
    else
      puts 'Unable to find the specified item.'.red
    end

  ##########
  # Remove #
  ##########
  when 'r'
    puts 'Remove which equipment?'
    equipment_name = gets.strip
    remove_item($hero, equipment_name)
  end
end

# DEFEAT IS NOT THE END! Simply return to the map and try again. While 'health' will be fully restored, consumable items used in combat remain lost.
