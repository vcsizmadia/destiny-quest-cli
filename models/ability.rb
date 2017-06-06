puts '... ./models/ability.rb'.light_black



class Ability
  # @version 20170526
  def initialize(hash = {})
    @data = {
      'id'                          => nil,
      'is_usable_once_per_combat'   => false,
      'is_usable_once_per_item'     => false,
      'is_usable_only_after_a_roll' => false,
      'name'                        => nil,
      # 'phases'                      => [],
      'type'                        => nil
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
