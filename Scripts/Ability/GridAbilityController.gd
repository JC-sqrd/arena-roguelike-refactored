class_name GridAbilityController extends AbilityController


var caster : Entity
var active : bool = false
var controller_context : Dictionary[StringName, Variant]

func initialize(caster : PlayerEntity):
	self.caster = caster
	active = true
	controller_context = generate_controller_context()
	_on_grid_ability_controller_initialize()
	pass

func start_ability():
	_on_start_ability()
	pass

func _on_start_ability():
	pass

func _on_grid_ability_controller_initialize():
	pass


func generate_controller_context() -> Dictionary[StringName, Variant]:
	var context : Dictionary[StringName, Variant] = {}
	context["source"] = caster
	context["caster"] = caster
	context["caster_stats"] = caster.stats
	return context
