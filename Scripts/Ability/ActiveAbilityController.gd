class_name ActiveAbilityController extends AbilityController

var active : bool = false
var caster : Entity

var effects : Array[Effect]
signal ability_finished(abiltiy : ActiveAbilityController)

func initialize(caster : Entity):
	self.caster = caster
	active = true
	controller_context = generate_controller_context()
	_on_initialized()
	pass

func _on_initialized():
	pass

func start_ability():
	execute()
	pass

func execute():
	end()
	pass

func end():
	ability_finished.emit(self)
	pass

func generate_effects_from_templates(templates : Array[EffectTemplate], context : Dictionary[StringName, Variant]) -> Array[Effect]:
	var effects : Array[Effect]
	for template in templates:
		effects.append(template.build_effect(context))
		pass
	return effects

func generate_controller_context() -> Dictionary[StringName, Variant]:
	var context : Dictionary[StringName, Variant] = {}
	context["source"] = caster
	context["caster"] = caster
	context["caster_stats"] = caster.stats
	context["controller"] = self
	return context
