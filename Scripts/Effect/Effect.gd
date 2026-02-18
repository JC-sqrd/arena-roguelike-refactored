@abstract
class_name Effect extends RefCounted

var mutators : Array[StatMutator]
var modifiers : Array[StatModifier]
var applied_tags : Array[StringName]
var block_tags : Array[StringName]

func apply_effect(stats : Stats, context : Dictionary = {}):
	pass

func add_modifier(modifier : StatModifier):
	pass

func add_mutator(mutator : StatMutator):
	pass

func _to_string() -> String:
	return "Effect modifiers: " + str(modifiers) + " Effect mutators: " + str(mutators)
