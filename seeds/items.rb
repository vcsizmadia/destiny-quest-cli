puts '... ./seeds/item.rb'.light_black

$items = []

###################
# Boar-hide boots #
###################
# TODO: Can be uncommented once the 'Steadfast' Ability has been fully implemented.
# Item.add({
#   'ability_id' => Ability.find_by_name('Steadfast')['id'],
#   'armour'     => 1,
#   'equipment'  => 'feet',
#   'name'       => 'Boar-hide boots',
#   'speed'      => 1
# })

####################
# Circle of thorns #
####################
Item.add({
  'ability_id' => Ability.find_by_name('Thorns')['id'],
  'equipment'  => 'ring',
  'name'       => 'Circle of thorns'
})

##################
# Crone's dagger #
##################
Item.add({
  'category'  => 'dagger',
  'equipment' => 'main hand',
  'magic'     => 1,
  'name'      => 'Crone\'s dagger',
  'speed'     => 1
})

#####################
# Duskleaf doubloon #
#####################
Item.add({
  'ability_id' => Ability.find_by_name('Charm')['id'],
  'brawn'      => 1,
  'equipment'  => 'chest',
  'name'       => 'Duskleaf doubloon',
  'speed'      => 1
})

######################
# Embroidered gloves #
######################
Item.add({
  'equipment' => 'gloves',
  'name'      => 'Embroidered gloves',
  'magic'     => 1,
  'speed'     => 1
})

#####################
# Essence of shadow #
#####################
Item.add({
  'ability_id' => Ability.find_by_name('Chill touch')['id'],
  'category'   => 'orb',
  'equipment'  => 'left hand',
  'magic'      => 1,
  'name'       => 'Essence of shadow',
  'speed'      => 1
})

##############
# Forest dew #
##############
# (2 uses)
# (backpack)
# Use any time in combat to restore your _health_ to full.

##################
# Gilbert's club #
##################
Item.add({
  'brawn'     => 3,
  'category'  => 'club',
  'equipment' => 'main hand',
  'name'      => 'Gilbert\'s club'
})

###############
# Goblinhewer #
###############
Item.add({
  'armour'    => 1,
  'category'  => 'sword',
  'equipment' => 'main hand',
  'name'      => 'Goblinhewer',
  'speed'     => 1
})

#################
# Healing salve #
#################
# (1 use)
# (backpack)
# Use any time in combat to restore 6 _health_.

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

###################
# Mercia's brandy #
###################
# (1 use)
# (backpack)
# Raises your _speed_ by 3 for one combat round.

################
# Miracle grow #
################
# (1 use)
# (backpack)
# Use any time in combat to raise your _brawn_ by 2 for one combat round.

######################
# Moth-eaten blanket #
######################
Item.add({
  'equipment' => 'cloak',
  'name'      => 'Moth-eaten blanket',
  'speed'     => 1
})

################
# Nightbringer #
################
Item.add({
  'ability_id' => Ability.find_by_name('Might of stone')['id'],
  'brawn'      => 4,
  'category'   => 'sword',
  'equipment'  => 'main hand',
  'name'       => 'Nightbringer',
  'speed'      => 1
})

#############
# Nightfall #
#############
Item.add({
  'ability_id' => Ability.find_by_name('Might of stone')['id'],
  'category'   => 'staff',
  'equipment'  => 'main hand',
  'magic'      => 4,
  'name'       => 'Nightfall',
  'speed'      => 1
})

###################
# Patchwork cloak #
###################
Item.add({
  'equipment' => 'cloak',
  'name'      => 'Patchwork cloak',
  'speed'     => 1
})

##################
# Pot of healing #
##################
# (1 use)
# (backpack)
# Use any time in combat to restore 4 _health_.

################
# Pot of magic #
################
# (1 use)
# (backpack)
# Use any time in combat to raise your _magic_ by 2 for one combat round.

################
# Pot of speed #
################
# (1 use)
# (backpack)
# Use any time in combat to raise your _speed_ by 2 for one combat round.

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

###################
# Rennie's slicer #
###################
Item.add({
  'ability_id' => Ability.find_by_name('First cut')['id'],
  'brawn'      => 1,
  'category'   => 'dagger',
  'equipment'  => 'left hand',
  'name'       => 'Rennie\'s slicer',
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

#############
# Silk robe #
#############
Item.add({
  'equipment' => 'chest',
  'name'      => 'Silk robe',
  'magic'     => 1
})

################
# Skullbreaker #
################
Item.add({
  'ability_id' => Ability.find_by_name('Pound')['id'],
  'brawn'      => 2,
  'category'   => 'club',
  'equipment'  => 'main hand',
  'name'       => 'Skullbreaker',
  'speed'      => 1
})

###############
# Spindlesilk #
###############
# (2 uses)
# (backpack)
# Perhaps a master clothier could do something with this fine silk.

################
# Stone collar #
################
Item.add({
  'ability_id' => Ability.find_by_name('Charm')['id'],
  'armour'     => 1,
  'equipment'  => 'necklace',
  'name'       => 'Stone collar'
})

################
# Stone shield #
################
Item.add({
  'ability_id' => Ability.find_by_name('Slam')['id'],
  'armour'     => 2,
  'category'   => 'shield',
  'equipment'  => 'left hand',
  'name'       => 'Stone shield',
  'speed'      => 1
})

##############
# Stone ward #
##############
Item.add({
  'ability_id' => Ability.find_by_name('Might of stone')['id'],
  'equipment'  => 'talisman',
  'name'       => 'Stone ward'
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

###################
# Trophy of bones #
###################
Item.add({
  'ability_id' => Ability.find_by_name('Charm')['id'],
  'armour'     => 1,
  'equipment'  => 'necklace',
  'magic'      => 1,
  'name'       => 'Trophy of bones'
})
