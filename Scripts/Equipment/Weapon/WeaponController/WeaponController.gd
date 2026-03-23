class_name WeaponController extends Node2D

@export var weapon_input : WeaponControllerInputStrategy
@export var weapon_upgrades : Array[WeaponUpgrade]

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

signal attack_to_start()
signal attack_started()
signal attack_to_execute()
signal attack_executed()
signal attack_to_end()
signal attack_end()

signal weapon_hit(hits : Array[RID], context : Dictionary[StringName, Variant])

func initialize(wielder : Entity):
	self.wielder = wielder
	for upgrade in weapon_upgrades:
		upgrade.apply_upgrade(self)
		pass
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
	attack_to_start.emit()
	_on_start()
	attack_started.emit()
	pass

func _on_start():
	pass

func execute_attack():
	pass

func _on_execute():
	pass

func end_attack():
	attack_to_end.emit()
	_on_end()
	attack_end.emit()
	pass

func _on_end():
	pass

func _process(delta: float) -> void:
	_on_process(delta)
	
	if !weapon_upgrades.size() <= 0:
		for upgrade in weapon_upgrades:
			upgrade.update(delta)
	pass

func _on_process(delta):
	pass

func input_pressed():
	pass

func input_held():
	pass

func input_released():
	pass

func generate_effects() -> Array[Effect]:
	return []

func apply_upgrade(upgrade : WeaponUpgrade):
	
	pass

func remove_upgrade():
	
	pass
func generate_controller_context() -> Dictionary[StringName, Variant]:
	var context : Dictionary[StringName, Variant] = {}
	context["source"] = wielder
	context["wielder"] = wielder
	context["wielder_stats"] = wielder.stats
	context["weapon_id"] = weapon_id
	context["controller"] = self
	return context
