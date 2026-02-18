class_name OverrideStatModifier extends StatModifier

var _value : float = 0
var old_value : float = 0

func _init(stat_id : StringName, value_provider : ValueProvider):
	self.value_provider = value_provider
	pass

func apply_modifier(stat : Stat, context : Dictionary = {}):
	old_value = stat.get_value()
	_value = value_provider.get_value(context)
	stat.set_value(_value)
	pass

func remove_modifier(stat : Stat, context : Dictionary = {}):
	stat.set_value(old_value)
	pass
