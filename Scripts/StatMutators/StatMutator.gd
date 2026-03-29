@abstract
class_name StatMutator extends RefCounted


var stat_id : StringName
var required_context : Array[ContextTag]
var value_provider : ValueProvider

var _value : float = 0 
@abstract func apply_mutator(stat : Stat, context : Dictionary = {})

func get_value() -> float:
	return _value

func cleanup():
	value_provider.cleanup()
	value_provider = null
	pass
