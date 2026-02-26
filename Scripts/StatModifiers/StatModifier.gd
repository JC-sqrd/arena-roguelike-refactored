@abstract
class_name StatModifier extends RefCounted


var stat_id : StringName
var required_context : Array[ContextTag]
var value_provider : ValueProvider

var _value : float = 0

func apply_modifier(stat : Stat, context : Dictionary[StringName, Variant] = {}):
	pass

func remove_modifier(stat : Stat, context : Dictionary[StringName, Variant] = {}):
	pass

func get_value() -> float:
	return _value
