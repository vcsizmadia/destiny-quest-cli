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
