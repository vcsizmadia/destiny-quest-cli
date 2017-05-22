puts '... abilities.rb'.light_black

class Ability
  def initialize(hash = {})
    @data = {
      'id'                        => nil,
      'is_usable_once_per_combat' => false,
      'name'                      => nil,
      'type'                      => nil
    }

    @data.merge!(hash)
  end

  #################
  # Class Methods #
  #################

  # @author Vilmos Csizmadia
  # @version 20170519
  def self.find(id)
    $abilities.detect {|a| a['id'] == id}
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

  def data
    @data
  end
end



# @author Vilmos Csizmadia
# @version 20170518
def list_abilities
  $abilities.each {|a| puts "#{a['id']}\t#{a['name']}"}
end

# The highest ID is currently 5.

#####################
#####################
## Ability Library ##
#####################
#####################

$abilities = [
  ############
  # Dominate #
  ############
  Ability.new({
    'description'               => 'Change the result of _one_ die you roll for damage to a [6]. You can only use this ability once per combat.',
    'id'                        => 5,
    'is_usable_once_per_combat' => true,
    'name'                      => 'Dominate',
    'type'                      => 'mo'
  }),

  ############
  # Fearless #
  ############
  Ability.new({
    'description'               => 'Use this ability to raise your _speed_ by 2 for one combat round. This ability can only be used once per combat.',
    'id'                        => 3,
    'is_usable_once_per_combat' => true,
    'name'                      => 'Fearless',
    'type'                      => 'sp'
  }),

  ############
  # Ferocity #
  ############
  # "Ferocity: If Mauler wins a combat round and inflicts health damage on your hero, the beast automatically raises its _speed_ to 7 for the next combat round."
  Ability.new({
    'description' => nil,
    'id'          => 2,
    'name'        => 'Ferocity',
    'type'        => nil
  }),

  ############
  # Savagery #
  ############
  Ability.new({
    'description'               => 'You may raise your _brawn_ or _magic_ score by 2 for one combat round. You can only use _savagery_ once per combat.',
    'id'                        => 4,
    'is_usable_once_per_combat' => true,
    'name'                      => 'Savagery',
    'type'                      => 'mo'
  }),

  #########
  # Venom #
  #########
  # "Venom: Once you have taken damage from the serpent, at the end of every combat round you must automatically lose 2 health."
  Ability.new({
    'description' => 'If your damage dice / damage score causes health damage to your opponent, they lose a further 2 _health_ at the end of every combat round, for the remainder of the combat. This ability ignores _armour_.',
    'id'          => 1,
    'name'        => 'Venom',
    'type'        => 'pa'
  })
]
