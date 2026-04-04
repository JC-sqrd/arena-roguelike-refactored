extends Node


signal effect_event_occured(effect_event : EffectEvent)

#signal damage_effect_event_occured(damage_event : DamageEffectEvent)

signal damage_event(damage_amount : float, target : Entity, source : Entity, context : Dictionary[StringName, Variant])
#signal entity_died(death_event : EntityDeathEvent)

signal entity_died(entity : Entity, context : Dictionary[StringName, Variant])

signal weapon_attack_started(weapon_controller : WeaponController)

signal weapon_to_attack()

signal weapon_attacked()

signal effect_hit(rid : RID, effect : Effect, context : Dictionary[StringName, Variant])

signal weapon_hit(hit : RID, weapon_effects : Array[Effect], context : Dictionary[StringName, Variant])

signal ability_start(ability_controller : AbilityController, context : Dictionary[StringName, Variant])
