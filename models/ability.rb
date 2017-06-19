puts '... ./models/ability.rb'.light_black



class Ability
  # @version 20170526
  def initialize(hash = {})
    @data = {
      'id'                              => nil,
      'is_only_usable_against_winner'   => false, # Only usable by the loser against the winner (if winner exists)...
      'is_only_usable_before_combat'    => false,
      'is_only_usable_for_attack_speed' => false, # Only usable during one of the 'attack speed' steps...
      'is_only_usable_for_damage_score' => false, # Only usable during one of the 'damage score' steps...
      'is_only_usable_once_per_combat'  => false,
      'is_only_usable_once_per_item'    => false, # Could be used multiple times if multiple Items grant it...
      'is_only_usable_post_roll'        => false, # Only usable after a roll...
      'is_only_usable_pre_roll'         => false, # Only usable before a roll...
      'is_passive'                      => false, # Cannot be manually selected...
      'name'                            => nil,
      'type'                            => nil
    }

    @data.merge!(hash)
  end

  #################
  # Class Methods #
  #################

  # @version 20170526
  def self.add(hash)
    $abilities << Ability.new({
      'id' => $abilities.length + 1
    }.merge!(hash))
  end

  # @version 20170519
  def self.find(id)
    $abilities.detect {|a| a['id'] == id}
  end

  # @version 20170526
  def self.find_by_name(name)
    $abilities.detect {|a| a['name'] == name}
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
