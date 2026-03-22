class_name WeaponController extends Node2D

@export var weapon_input : WeaponControllerInputStrategy

var weapon_id : StringName
var wielder : Entity
var wielder_stats : Stats
var weapon_stats : Stats
var listen_for_input : bool = false
var effects : Array[Effect]
var controller_context : Dictionary[StringName, Variant]
var on_cooldown : bool = false
var _cooldown : float = 0
var _curr_cooldown : float = 0

signal attack_start()
signal attack_executed()
signal attack_end()

signal weapon_hit(hits : Array[RID])

func initialize(wielder : Entity):
	self.wielder = wielder
	if weapon_input == null:
		weapon_input = InstantWeaponInput.new()
		weapon_input.initialize(self)
	else:
		weapon_input.initialize(self)
	#controller_context = generate_controller_context()
	_on_initialized()
	pass

func _on_initialized():
	pass

func start_attack():
	pass


func execute_attack():
	pass


func end_attack():
	pass

func input_pressed():
	pass

func input_held():
	pass

func input_released():
	pass

func generate_effects() -> Array[Effect]:
	return []

func generate_controller_context() -> Dictionary[StringName, Variant]:
	var context : Dictionary[StringName, Variant] = {}
	context["source"] = wielder
	context["caster"] = wielder
	context["caster_stats"] = wielder.stats
	context["controller"] = self
	return context
