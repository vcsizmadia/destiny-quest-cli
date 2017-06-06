puts '... ./models/item.rb'.light_black

class Item
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

  ################
  # Associations #
  ################

  def ability
    Ability.find(self['ability_id']) if self['ability_id']
  end

  #################
  # Class Methods #
  #################

  # @version 20170526
  def self.add(hash)
    $items << Item.new({
      'id' => $items.length + 1
    }.merge!(hash))
  end

  # @version 20170519
  def self.find(id)
    $items.detect {|i| i['id'] == id}
  end

  ####################
  # Instance Methods #
  ####################

  # @version 20170519
  def [](key)
    @data[key]
  end

  # @version 20170519
  def []=(key, value)
    @data[key] = value
  end

  # @version 20170519
  def data
    @data
  end
end
