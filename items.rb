puts '... items.rb'.light_black

# @author Vilmos Csizmadia
# @version 20170430
def equip_item(character, item_name)
  character_name = character['name']

  if item = get_item(item_name)
    equipment = item['equipment']

    puts "\nEquipping '#{item['name']}' into '#{equipment}' of '#{character_name}'...".light_black

    if character.has_key?(equipment)
      # There is a lot to this, so handle it in a separate method.
      remove_item(character, equipment)

      character[equipment] = item

      ##############
      # Attributes #
      ##############
      if item.has_key?('attributes') && item['attributes'].instance_of?(Hash)
        item['attributes'].keys.each do |a|
          value = item['attributes'][a]
          character[a] += value
          puts "... +#{value} to '#{a}'".light_black
        end

        # '... Them attributes are changin!'
      else
        '... No attribute changes necessary.'
      end
    else
      "... '#{character_name}' cannot have anything equipped in '#{equipment}'."
    end
  else
    puts "... Unable to find '#{item_name}'."
  end
end

# @author Vilmos Csizmadia
# @version 20170430
def get_item(name)
  if name
    @items.detect {|i| i['name'].downcase == name.downcase}
  end
end

# @author Vilmos Csizmadia
# @version 20170430
def list_items
  @items.each_with_index do |item, i|
    puts "#{i + 1}\t#{item['name']}\t#{item}"
  end
end

# @author Vilmos Csizmadia
# @version 20170430
def remove_item(character, equipment)
  if character.has_key?(equipment)
    if item = character[equipment]
      "\nRemoving '#{item['name']}' from '#{equipment}' of '#{character}'..."
      ##############
      # Attributes #
      ##############
      if item.has_key?('attributes') && item['attributes'].instance_of?(Array)
        '... Them attributes are changin!'
      else
        '... No attribute changes necessary.'
      end

      character[equipment] = nil
    else
      "... '#{character}' does not have anything equipped in '#{equipment}'."
    end
  else
    "... '#{character}' cannot have anything equipped in '#{equipment}'."
  end
end

@items = [
  # The apprentice
  {
    'attributes' => {
      'brawn' => 1,
      'magic' => 1
    },
    'category'  => 'sword',
    'equipment' => 'main hand',
    'id'        => 1,
    'name'      => 'The apprentice'
  }
]
