puts '... items.rb'.light_black

class Item
  # @author Vilmos Csizmadia
  # @version 20170519
  def initialize(hash = {})
    @data = {
      'ability_id' => nil,
      'armour'     => nil,
      'brawn'      => nil,
      'category'   => nil,
      'equipment'  => nil,
      'id'         => nil,
      'magic'      => nil,
      'name'       => nil,
      'speed'      => nil
    }

    @data.merge!(hash)
  end

  #################
  # Class Methods #
  #################

  # @author Vilmos Csizmadia
  # @version 20170519
  def self.find(id)
    $items.detect {|i| i['id'] == id}
  end

  # @author Vilmos Csizmadia
  # @version 20170521
  def self.list
    $items.each {|i| puts "#{i['id']}\t#{i['name']}\t#{i['equipment']}"}
    # .each_with_index do |item, i|
    #   puts "#{i + 1}\t#{item['name']}\t#{item}"
    # end
  end

  ####################
  # Instance Methods #
  ####################

  # @author Vilmos Csizmadia
  # @version 20170519
  def [](key)
    @data[key]
  end

  # @author Vilmos Csizmadia
  # @version 20170519
  def []=(key, value)
    @data[key] = value
  end

  # @author Vilmos Csizmadia
  # @version 20170519
  def data
    @data
  end
end

##################
##################
## Item Library ##
##################
##################

# The highest ID is currently 4.

$items = [
  ################
  # Mauler's maw #
  ################
  Item.new({
    'ability_id' => 3, # Fearless
    'armour'     => 1,
    'equipment'  => 'head',
    'id'         => 2,
    'name'       => 'Mauler\'s maw',
    'speed'      => 1
  }),

  #############
  # Rage claw #
  #############
  Item.new({
    'ability_id' => 5, # Dominate
    'brawn'      => 1,
    'category'   => 'fist weapon',
    'equipment'  => 'left hand',
    'id'         => 4,
    'name'       => 'Rage claw',
    'speed'      => 1
  }),

  ###############
  # Savage pelt #
  ###############
  Item.new({
    'ability_id' => 4, # Savagery
    'brawn'      => 1,
    'equipment'  => 'cloak',
    'id'         => 3,
    'magic'      => 1,
    'name'       => 'Savage pelt'
  }),

  ##################
  # The apprentice #
  ##################
  Item.new({
    'brawn'     => 1,
    'category'  => 'sword',
    'equipment' => 'main hand',
    'id'        => 1,
    'magic'     => 1,
    'name'      => 'The apprentice'
  })
]
