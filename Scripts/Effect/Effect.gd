@abstract
class_name Effect extends RefCounted

var mutators : Array[StatMutator]
var modifiers : Array[StatModifier]
var applied_tags : Array[StringName]
var block_tags : Array[StringName]

var effect_events : Array[EffectEventTemplate]

var effect_context : Dictionary[StringName, Variant]

func apply_effect(stats : Stats):
	pass

func add_modifier(modifier : StatModifier):
	pass

func add_mutator(mutator : StatMutator):
	pass

func invoke_effect_events():
	for event_template in effect_events:
		event_template.build_effect_event(self)
		pass
	pass

func _to_string() -> String:
	return "Effect modifiers: " + str(modifiers) + " Effect mutators: " + str(mutators)
