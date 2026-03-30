@abstract
class_name Effect extends RefCounted

var mutator : StatMutator
var modifier : StatModifier
var applied_tags : Array[StringName]
var block_tags : Array[StringName]
var effect_id : StringName

var effect_events : Array[EffectEventTemplate]

var effect_context : Dictionary[StringName, Variant]

var _freed : bool = false

signal applied_effect(effect : Effect)
signal invoked_effect_events()

func apply_effect(stats : Stats):
	pass

func add_modifier(modifier : StatModifier):
	pass

func add_mutator(mutator : StatMutator):
	pass

func invoke_effect_events():
	for event_template in effect_events:
		var effect_event : EffectEvent = event_template.build_effect_event(self)
		effect_event.invoke_event(effect_context)
		pass
	invoked_effect_events.emit()
	pass

func cleanup():
	print("EFFECT CLEANUP")
	_freed = true
	if mutator != null:
		mutator.cleanup()
	mutator = null
	if modifier != null:
		modifier.cleanup()
	modifier = null
	pass

func _to_string() -> String:
	return "Effect modifier: " + str(modifier) + " Effect mutators: " + str(mutator)
