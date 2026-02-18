class_name FlatStatModifier extends StatModifier

enum Mode {ADD = 1, SUBTRACT = -1}
@export var mode : Mode = Mode.ADD

var _value : float

func _init(stat_id : StringName, value_provider : ValueProvider, mode : Mode):
	self.stat_id = stat_id
	self.value_provider = value_provider
	self.mode = mode
	pass

func apply_modifier(stat : Stat, context : Dictionary = {}):
	_value = value_provider.get_value(context)
	stat.add(_value * mode)
	pass

func remove_modifier(stat : Stat, context : Dictionary = {}):
	stat.add(-(_value * mode))
	pass
