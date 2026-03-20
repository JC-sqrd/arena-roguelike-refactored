extends Node

signal effect_event_occured(effect_event : EffectEvent)

signal entity_died(death_event : EntityDeathEvent)

#signal entity_died(entity : Entity, context : Dictionary[StringName, Variant])

signal weapon_attack(attack_event : AttackEvent)

signal effect_hit(rid : RID, effect : Effect, context : Dictionary[StringName, Variant])

signal weapon_hit(hits : Array[RID], weapon_effects : Array[Effect], context : Dictionary[StringName, Variant])

signal ability_start(ability_controller : AbilityController, context : Dictionary[StringName, Variant])
