class_name GridAbilityController extends AbilityController


var stats_template : StatsTemplate
var ability_stats : Stats

var caster : Entity
var active : bool = false
var effects : Array[Effect]
var adjacent_controllers : Array[GridAbilityController]
var level : int = 1

signal to_send_effect(hit : RID, effects : Array[Effect])
signal effect_sent(hit : RID, effects : Array[Effect])

signal adjacent_contollers_updated(controllers : Array[GridAbilityController])

func initialize(caster : Entity):
	self.caster = caster as PlayerEntity
	active = true
	controller_context = generate_controller_context()
	_initialize_ability_stats()
	_on_initialized()
	pass

func start_ability():
	_on_start_ability()
	pass

func _on_start_ability():
	pass

func _on_initialized():
	pass

func update_adjacent_controllers(new_adjacent_controllers : Array[GridAbilityController]):
	adjacent_controllers = new_adjacent_controllers
	adjacent_contollers_updated.emit(new_adjacent_controllers)
	pass

func generate_effects() -> Array[Effect]:
	return []

func generate_controller_context() -> Dictionary[StringName, Variant]:
	var context : Dictionary[StringName, Variant] = {}
	context["source"] = caster
	context["caster"] = caster
	context["caster_stats"] = caster.stats
	context["ability_stats"] = ability_stats
	context["controller"] = self
	return context

func _initialize_ability_stats():
	if stats_template == null:
		stats_template = StatsTemplate.new()
	ability_stats = Stats.new()
	ability_stats.stats_template = stats_template
	ability_stats.initialize()
	pass

func get_current_cooldown() -> float:
	return 0

func set_current_cooldown(cd : float):
	pass

func _on_exit_tree():
	pass

func _exit_tree() -> void:
	caster = null
	ability_stats.cleanup()
	ability_stats = null
	_on_exit_tree()
	pass
