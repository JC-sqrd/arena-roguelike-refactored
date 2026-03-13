class_name ActiveAbilityController extends AbilityController

var active : bool = false
var caster : Entity

signal ability_finished(abiltiy : ActiveAbilityController)

func initialize(caster : Entity):
	self.caster = caster
	active = true
	controller_context = generate_controller_context()
	_on_initialized()
	pass

func _on_initialized():
	pass

func start():
	execute()
	pass

func execute():
	end()
	pass

func end():
	ability_finished.emit(self)
	pass


func generate_controller_context() -> Dictionary[StringName, Variant]:
	var context : Dictionary[StringName, Variant] = {}
	context["source"] = caster
	context["caster"] = caster
	context["caster_stats"] = caster.stats
	return context
