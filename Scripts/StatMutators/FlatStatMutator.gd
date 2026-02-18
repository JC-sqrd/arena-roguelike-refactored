class_name FlatStatMutator extends StatMutator



#Super Class Properties
#var stat_id : StringName
#var required_context : Array[ContextTag]
#var value_provider : ValueProvider

enum Mode {ADD = 1, SUBTRACT = -1}
var mode : Mode = Mode.ADD



func _init(stat_id : StringName, value_provider : ValueProvider, required_context : Array[ContextTag], mode : Mode = Mode.ADD):
	self.stat_id = stat_id
	self.value_provider = value_provider
	self.required_context = required_context
	self.mode = mode
	pass

func apply_mutator(stat : Stat, context : Dictionary[StringName, Variant] = {}):
	var _value : float = 0
	_value = value_provider.get_value(context)
	stat.add(_value * mode)
	pass
