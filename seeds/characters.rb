puts '... ./seeds/characters.rb'.light_black

$characters = []

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

###################
# Goblin poachers #
###################
Character.add({
  'name' => 'Goblin poachers',

  # Attributes
  'brawn'  => 1,
  'health' => 20
})

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

###########
# Serpent #
###########
Character.add({
  'name' => 'Serpent',

  # Attributes
  'health' => 12
})
.add_ability(Ability.find_by_name('Venom'))

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
