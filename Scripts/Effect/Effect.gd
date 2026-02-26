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

func _to_string() -> String:
	return "Effect modifiers: " + str(modifiers) + " Effect mutators: " + str(mutators)
