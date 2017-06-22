puts '... ./seeds/characters.rb'.light_black

$characters = []

##########
# Ghouls #
##########
c = Character.add({
  'name' => 'Ghouls',

  # Attributes
  'armour' => 2,
  'brawn'  => 3,
  'health' => 30,
  'speed'  => 5
})
c.add_ability(Ability.find_by_name('Piercing claws'))

###################
# Goblin poachers #
###################
Character.add({
  'name' => 'Goblin poachers',

  # Attributes
  'brawn'  => 1,
  'health' => 20
})

########
# Hero #
########
c = Character.add({
  'name' => 'Hero',

  # Attributes
  'health' => 30,
  # 'speed'  => 8,

  # Gold crowns ("money pouch")
  'gold' => 10
})
# c.add_ability(Ability.find_by_name('Charm'))
# c.add_ability(Ability.find_by_name('Charm'))
# .add_ability(Ability.find_by_name('Dominate'))
# .add_ability(Ability.find_by_name('Fearless'))
# .add_ability(Ability.find_by_name('Savagery'))
# c.add_ability(Ability.find_by_name('Slam'))

#############
# Humbaroth #
#############
# "Humbaroth the giant"
Character.add({
  'name' => 'Humbaroth',

  # Attributes
  'armour' => 4,
  'brawn'  => 9,
  'health' => 35,
  'speed'  => 4
})
.add_ability(Ability.find_by_name('Punishing blows'))

###############
# Lake spirit #
###############
Character.add({
  'name' => 'Lake spirit',

  # Attributes
  'armour' => 2,
  'health' => 50,
  'magic'  => 5,
  'speed'  => 4
})

###################
# Malachi of fire #
###################
Character.add({
  'name' => 'Malachi of fire',

  # Attributes
  'armour' => 2,
  'health' => 20,
  'magic'  => 4,
  'speed'  => 4
})
.add_ability(Ability.find_by_name('Fiery aura'))

##########
# Mauler #
##########
Character.add({
  'name' => 'Mauler',

  # Attributes
  'armour' => 5,
  'brawn'  => 8,
  'health' => 30,
  'speed'  => 5
})
.add_ability(Ability.find_by_name('Ferocity'))

################
# Mist stalker #
################
Character.add({
  'name' => 'Mist stalker',

  # Attributes
  'brawn'  => 1,
  'health' => 10
})

##########
# Rennie #
##########
c = Character.add({
  'name' => 'Rennie',

  # Attributes
  'armour' => 2,
  'brawn'  => 2,
  'health' => 15,
  'speed'  => 3
})
c.add_ability(Ability.find_by_name('First cut'))

############
# Ruffians #
############
c = Character.add({
  'name' => 'Ruffians',

  # Attributes
  'armour' => 1,
  'brawn'  => 3,
  'health' => 15,
  'speed'  => 2
})
c.add_ability(Ability.find_by_name('Crone\'s dagger'))

###########
# Serpent #
###########
Character.add({
  'name' => 'Serpent',

  # Attributes
  'health' => 12
})
.add_ability(Ability.find_by_name('Venom'))

###########
# Spindle #
###########
c = Character.add({
  'name' => 'Spindle',

  # Attributes
  'armour' => 3,
  'brawn'  => 5,
  'health' => 30,
  'speed'  => 5
})
c.add_ability(Ability.find_by_name('Venom'))
c.add_ability(Ability.find_by_name('Webbed'))

###################
# Storm elemental #
###################
Character.add({
  'name' => 'Storm elemental',

  # Attributes
  'armour' => 1,
  'health' => 25,
  'magic'  => 1,
  'speed'  => 2
})
.add_ability(Ability.find_by_name('Charged'))

###########
# Turnips #
###########
Character.add({
  'name' => 'Turnips',

  # Attributes
  'armour' => 1,
  'health' => 10
})

#############
# Zalladell #
#############
c = Character.add({
  'name' => 'Zalladell',

  # Attributes
  'armour' => 4,
  'health' => 40,
  'magic'  => 7,
  'speed'  => 5
})
c.add_ability(Ability.find_by_name('Bewitched'))
c.add_ability(Ability.find_by_name('Black sigils'))
