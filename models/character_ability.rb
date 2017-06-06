puts '... ./models/character_ability.rb'.light_black

$character_abilities          = []
$character_ability_id_counter = 0 # Use this to keep track of Character Ability IDs.

class CharacterAbility
  # @version 20170601
  def initialize(character, ability, item)
    $character_ability_id_counter += 1

    @data = {
      'ability_id'   => ability['id'],
      'character_id' => character['id'],
      'id'           => $character_ability_id_counter,
      'item_id'      => item ? item['id'] : nil
    }
  end

  ################
  # Associations #
  ################

  # @version 20170529
  def ability
    Ability.find(self['ability_id'])
  end

  # @note CURRENTLY UNUSED!
  # @version 20170529
  # def character
  #   Character.find(self['character_id'])
  # end

  #################
  # Class Methods #
  #################

  # @version 20170601
  def self.create(character, ability, item)
    $character_abilities << self.new(character, ability, item)
  end

  # @version 20170605
  def self.find(id)
    $character_abilities.detect {|ca| ca['id'] == id}
  end

  ####################
  # Instance Methods #
  ####################

  # @version 20170529
  def [](key)
    @data[key]
  end

  # @version 20170529
  def []=(key, value)
    @data[key] = value
  end

  # @version 20170531
  def data
    @data
  end

  # @version 20170601
  def destroy
    $character_abilities.delete_at(
      $character_abilities.index {|ca| ca['id'] == self['id']}
    )
  end
end
