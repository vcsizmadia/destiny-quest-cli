puts '... items.rb'.light_black

$items = []

class Item
  # @author Vilmos Csizmadia
  # @version 20170526
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
  # @version 20170526
  def self.add(hash)
    $items << Item.new({
      'id' => $items.length + 1
    }.merge!(hash))
  end

  # @author Vilmos Csizmadia
  # @version 20170519
  def self.find(id)
    $items.detect {|i| i['id'] == id}
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

##################
# Crone's dagger #
##################
Item.add({
  'category'  => 'dagger',
  'equipment' => 'main hand',
  'name'      => 'Crone\'s dagger',
  'magic'     => 1,
  'speed'     => 1
})

##################
# Gilbert's club #
##################
Item.add({
  'brawn'     => 3,
  'category'  => 'club',
  'equipment' => 'main hand',
  'name'      => 'Gilbert\'s club'
})

################
# Mauler's maw #
################
Item.add({
  'ability_id' => Ability.find_by_name('Fearless')['id'],
  'armour'     => 1,
  'equipment'  => 'head',
  'name'       => 'Mauler\'s maw',
  'speed'      => 1
})

######################
# Moth-eaten blanket #
######################
Item.add({
  'equipment' => 'cloak',
  'name'      => 'Moth-eaten blanket',
  'speed'     => 1
})

#############
# Rage claw #
#############
Item.add({
  'ability_id' => Ability.find_by_name('Dominate')['id'],
  'brawn'      => 1,
  'category'   => 'fist weapon',
  'equipment'  => 'left hand',
  'name'       => 'Rage claw',
  'speed'      => 1
})

###############
# Savage pelt #
###############
Item.add({
  'ability_id' => Ability.find_by_name('Savagery')['id'],
  'brawn'      => 1,
  'equipment'  => 'cloak',
  'magic'      => 1,
  'name'       => 'Savage pelt'
})

##################
# The apprentice #
##################
Item.add({
  'brawn'     => 1,
  'category'  => 'sword',
  'equipment' => 'main hand',
  'magic'     => 1,
  'name'      => 'The apprentice'
})
