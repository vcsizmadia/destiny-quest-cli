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

require './combat.rb'
require './methods.rb'
require './models/ability.rb' # Must go first due to Ability declarations used by Character and Item initializations.
require './models/character.rb'
require './models/character_ability.rb'
require './models/item.rb'
require './seeds/abilities.rb' # Must go first due to Ability declarations used by Character and Item initializations.
require './seeds/characters.rb'
require './seeds/items.rb'

###################
# Challenge Tests #
###################
# is_success = roll + roll + character['<name of attribute being tested>'] >= <value of attribute treshold>

####################
# Global Variables #
####################
$combat  = nil
$hero    = $characters[0] # Temporary...
$serpent = $characters[1] # Temporary...

puts 'The primary goal of DestinyQuest is to equip your hero with better weapons, armour and equipment.'

hp 'Commands'
puts '- a    ... Show a specific ability (or list them all).'
puts '- c    ... Show a specific character (or list them all).'
puts '- i    ... Show a specific item (or list them all).'
puts '- f    ... Initiate combat.'
puts '- e    ... Equip an item.'
puts '- r    ... Remove the item in the specified equipment slot.'
puts '- x    ... Exit.'

input = ''

while input != 'x'
  print ': '
  input = gets.strip

  case input
  when 'a'
    #############
    # Abilities #
    #############
    puts 'Enter the ID of the ability (or \'*\' to list them all):'
    input = gets.strip

    if input == '*'
      $abilities.each {|a| puts "#{a['id']}\t#{a['name']}"}
    elsif a = Ability.find(input.to_i)
      hp a['name']
      ap a.data
    else
      puts 'Unable to find the specified ability.'.red
    end
  when 'c'
    ##############
    # Characters #
    ##############
    puts 'Enter the ID of the character (or \'*\' to list them all):'
    input = gets.strip

    if input == '*'
      $characters.each {|c| puts "#{c['id']}\t#{c['name']}"}
    elsif c = Character.find(input.to_i)
      hp c['name']

      puts "\nAttributes".light_black
      puts '**********'.light_black

      ap c.data

      puts "\nAbilities".light_black
      puts '*********'.light_black

      c.character_abilities.each {|ca| ap ca.data}
    else
      puts 'Unable to find the specified character.'.red
    end
  when 'e'
    #########
    # Equip #
    #########
    puts 'Enter the ID of the item you wish to equip:'
    id = gets.strip.to_i

    if item = Item.find(id)
      $hero.equip(item)
    end
  when 'f'
    #########
    # Fight #
    #########
    $combat = Combat.new(Character.find(1), Character.find(8)).fight
  when 'i'
    #########
    # Items #
    #########
    puts 'Enter the ID of the item (or \'*\' to list them all):'
    input = gets.strip

    if input == '*'
      $items.each {|i| puts "#{pad(i['id'], 3)} #{pad(i['name'], 19)} #{pad(i['equipment'], 10)} #{i.ability ? i.ability['name'] : nil}"}
    elsif i = Item.find(input.to_i)
      hp i['name']
      ap i.data
    else
      puts 'Unable to find the specified item.'.red
    end
  when 'u'
    ###########
    # Unequip #
    ###########
    puts 'Unequip which equipment?'

    Character.equipment_names.each do |e|
      puts e if $hero[e]
    end

    equipment_name = gets.strip
    $hero.unequip(equipment_name)
  end
end

# DEFEAT IS NOT THE END! Simply return to the map and try again. While 'health' will be fully restored, consumable items used in combat remain lost.
