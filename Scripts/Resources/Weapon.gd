@abstract
class_name Weapon extends Item

@export var effect_templates : Array[EffectTemplate]

var wielder : Entity
var wielder_stats : Stats

var _weapon_stats : Stats
var _weapon_context : Dictionary[StringName, Variant]
var _weapon_effects : Array[Effect]

var active_controller : WeaponController

signal equipped()
signal unequipped()

@abstract
func equip(context : EquipContext)

@abstract
func unequip()

@abstract
func generate_effect_context(weapon_stats : Stats) -> Dictionary[StringName, Variant]

@abstract
func generate_weapon_stats() -> Stats

@abstract
func generate_effects(context : Dictionary[StringName, Variant])-> Array[Effect]

func get_active_controller() -> WeaponController:
	return active_controller
