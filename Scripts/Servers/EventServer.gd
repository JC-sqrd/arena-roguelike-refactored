extends Node

signal effect_event_occured(effect_event : EffectEvent)

signal entity_died(entity : Entity, context : Dictionary[StringName, Variant])

signal weapon_attack(attack_event : AttackEvent)
