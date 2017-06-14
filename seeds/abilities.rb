puts '... ./seeds/abilities.rb'.light_black

$abilities = []

# Combat (co): These abilities are used either before or after you (or your opponent) roll for damage. Usually these will increase the number of dice you can roll or allow you to block or dodge your opponent's attacks. You can only use one combat ability per combat round.

# Modifier (mo): Modifier abilities allow you to boost your attribute scores or influence dice that you have already rolled. You can use as many different modifier abilities as you wish during a combat round.

# Passive (pa): Passive abilities (such as 'bleed' and 'venom') are typically applied at the end of a combat round, once you or your opponent has taken health damage. These abilities happen automatically, based on their description.

# Speed (sp): These abilities can be used at the start of a combat round (before you roll for attack speed), and will eventually influence how many dice you can roll or reduce the number of dice your opponent can roll for speed. You can only use one speed ability per combat round.

###########
# Charged #
###########
# 'Charged: Each time you inflict health damage on the elemental, you take 2 damage in return. This ability ignores _armour_.'
Ability.add({
  'is_passive' => true,
  'name'       => 'Charged'
})

#########
# Charm #
#########
Ability.add({
  'description'                  => 'You may re-roll one of your hero\'s die any time during a combat. You must accept the result of the second roll. If you have multiple items with the _charm_ ability, each one give you a re-roll.',
  'is_only_usable_once_per_item' => true,
  'is_only_usable_post_roll'     => true,
  'name'                         => 'Charm',
  'type'                         => 'mo'
})

###############
# Chill touch #
###############
Ability.add({
  'description'                     => 'Use this ability to reduce your opponent\'s _speed_ by 2 for one combat round. You can only use _chill touch_ once per combat.',
  'is_only_usable_for_attack_speed' => true,
  'is_only_usable_once_per_combat'  => true,
  'name'                            => 'Chill touch',
  'type'                            => 'sp'
})

############
# Dominate #
############
Ability.add({
  'description'                    => 'Change the result of _one_ die you roll for damage to a [6]. You can only use this ability once per combat.',
  'is_only_usable_once_per_combat' => true,
  'is_only_usable_post_roll'       => true,
  'name'                           => 'Dominate',
  'type'                           => 'mo'
})

############
# Fearless #
############
Ability.add({
  'description'                     => 'Use this ability to raise your _speed_ by 2 for one combat round. This ability can only be used once per combat.',
  'is_only_usable_for_attack_speed' => true,
  'is_only_usable_once_per_combat'  => true,
  'is_only_usable_pre_roll'         => true,
  'name'                            => 'Fearless',
  'type'                            => 'sp'
})

############
# Ferocity #
############
# "Ferocity: If Mauler wins a combat round and inflicts health damage on your hero, the beast automatically raises its _speed_ to 7 for the next combat round."
Ability.add({
  'is_passive' => true,
  'name'       => 'Ferocity'
})

##############
# Fiery aura #
##############
# "Fiery aura: You automatically take 3 damage at the end of each combat round. This ability ignores _armour_."
Ability.add({
  'is_passive' => true,
  'name'       => 'Fiery aura'
})

##################
# Might of stone #
##################
Ability.add({
  'description'                    => 'You may instantly increase your _armour_ score by 3 for one combat round. You can only use this ability once per combat.',
  'is_only_usable_once_per_combat' => true,
  'name'                           => 'Might of stone',
  'type'                           => 'mo'
})

#########
# Pound #
#########
Ability.add({
  'description'                     => 'A mighty blow that increases your damage score by 3. However, in the next combat round, you must lower your _speed_ by 1. This ability can only be used once per combat.',
  'is_only_usable_for_damage_score' => true,
  'is_only_usable_once_per_combat'  => true,
  'name'                            => 'Pound',
  'type'                            => 'co'
})

###################
# Punishing blows #
###################
# "Punishing blows: Each time Humbaroth inflicts health damage, your _armour_ is lowered by 1. (Your _armour_ value is restored after the combat is over.)"
Ability.add({
  'is_passive' => true,
  'name'       => 'Punishing blows'
})

############
# Savagery #
############
Ability.add({
  'description'                    => 'You may raise your _brawn_ or _magic_ score by 2 for one combat round. You can only use _savagery_ once per combat.',
  'is_only_usable_once_per_combat' => true,
  'name'                           => 'Savagery',
  'type'                           => 'mo'
})

########
# Slam #
########
Ability.add({
  'description'                     => 'Use this ability to stop your opponent rolling for damage when they have won a round. In the next combat round, your opponent\'s _speed_ is reduced by 1. You can only use this ability once per combat.',
  'is_only_usable_against_winner'   => true,
  'is_only_usable_for_damage_score' => true,
  'is_only_usable_once_per_combat'  => true,
  'is_only_usable_pre_roll'         => true,
  'name'                            => 'Slam',
  'type'                            => 'co'
})

#############
# Steadfast #
#############
# TODO: To be implemented once we encounter a Character with the 'Knockdown' Ability for easier testing. Note how this needs to be applied before the first round of combat even begins. It is unlike other passive Abilities (such as 'Venom').
# Ability.add({
#   'description' => 'You are immune to _knockdown_. If an opponent has this ability, you can ignore it.',
#   'is_passive'  => true,
#   'name'        => 'Steadfast',
#   'type'        => 'pa'
# })

#########
# Venom #
#########
# "Venom: Once you have taken damage from the serpent, at the end of every combat round you must automatically lose 2 health."
Ability.add({
  'description' => 'If your damage dice / damage score causes health damage to your opponent, they lose a further 2 _health_ at the end of every combat round, for the remainder of the combat. This ability ignores _armour_.',
  'is_passive'  => true,
  'name'        => 'Venom',
  'type'        => 'pa'
})

############
# Handlers #
############


