@abstract
class_name StatModifier extends RefCounted


var stat_id : StringName
var required_context : Array[ContextTag]
var value_provider : ValueProvider


func apply_modifier(stat : Stat, context : Dictionary = {}):
	pass

func remove_modifier(stat : Stat, context : Dictionary = {}):
	pass
