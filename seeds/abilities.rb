puts '... ./seeds/abilities.rb'.light_black

$abilities = []

###########
# Charged #
###########
# 'Charged: Each time you inflict health damage on the elemental, you take 2 damage in return. This ability ignores _armour_.'
Ability.add({
  'name' => 'Charged'
})

#########
# Charm #
#########
Ability.add({
  'description'                 => 'You may re-roll one of your hero\'s die any time during a combat. You must accept the result of the second roll. If you have multiple items with the _charm_ ability, each one give you a re-roll.',
  'is_usable_once_per_item'     => true,
  'is_usable_only_after_a_roll' => true,
  'name'                        => 'Charm',
  'type'                        => 'mo'
})

############
# Dominate #
############
Ability.add({
  'description'                 => 'Change the result of _one_ die you roll for damage to a [6]. You can only use this ability once per combat.',
  'is_usable_once_per_combat'   => true,
  'is_usable_only_after_a_roll' => true,
  'name'                        => 'Dominate',
  # 'phases'                      => ['post-roll'],
  'type'                        => 'mo'
})

############
# Fearless #
############
Ability.add({
  'description'               => 'Use this ability to raise your _speed_ by 2 for one combat round. This ability can only be used once per combat.',
  'is_usable_once_per_combat' => true,
  'name'                      => 'Fearless',
  # 'phases'                    => ['round start'],
  'type'                      => 'sp'
})

############
# Ferocity #
############
# "Ferocity: If Mauler wins a combat round and inflicts health damage on your hero, the beast automatically raises its _speed_ to 7 for the next combat round."
Ability.add({
  'name' => 'Ferocity'
})

##############
# Fiery aura #
##############
# "Fiery aura: You automatically take 3 damage at the end of each combat round. This ability ignores _armour_."
Ability.add({
  'name' => 'Fiery aura'
})

##################
# Might of stone #
##################
Ability.add({
  'description'               => 'You may instantly increase your _armour_ score by 3 for one combat round. You can only use this ability once per combat.',
  'is_usable_once_per_combat' => true,
  'name'                      => 'Might of stone',
  'type'                      => 'mo'
})

###################
# Punishing blows #
###################
# "Punishing blows: Each time Humbaroth inflicts health damage, your _armour_ is lowered by 1. (Your _armour_ value is restored after the combat is over.)"
Ability.add({
  'name' => 'Punishing blows'
})

############
# Savagery #
############
Ability.add({
  'description'               => 'You may raise your _brawn_ or _magic_ score by 2 for one combat round. You can only use _savagery_ once per combat.',
  'is_usable_once_per_combat' => true,
  'name'                      => 'Savagery',
  'type'                      => 'mo'
})

########
# Slam #
########
Ability.add({
  'description'               => 'Use this ability to stop your opponent rolling for damage when they have won a round. In the next combat round, your opponent\'s _speed_ is reduced by 1. You can only use this ability once per combat.',
  'is_usable_once_per_combat' => true,
  'name'                      => 'Slam',
  'type'                      => 'co'
})

#########
# Venom #
#########
# "Venom: Once you have taken damage from the serpent, at the end of every combat round you must automatically lose 2 health."
Ability.add({
  'description' => 'If your damage dice / damage score causes health damage to your opponent, they lose a further 2 _health_ at the end of every combat round, for the remainder of the combat. This ability ignores _armour_.',
  'name'        => 'Venom',
  'type'        => 'pa'
})
