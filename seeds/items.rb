puts '... ./seeds/item.rb'.light_black

$items = []

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
