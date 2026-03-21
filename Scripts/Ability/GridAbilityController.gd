class_name GridAbilityController extends AbilityController


var caster : Entity
var active : bool = false
var effects : Array[Effect]
var adjacent_controllers : Array[GridAbilityController]

signal adjacent_contollers_updated(controllers : Array[GridAbilityController])

func initialize(caster : Entity):
	self.caster = caster as PlayerEntity
	active = true
	controller_context = generate_controller_context()
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
	context["controller"] = self
	return context
