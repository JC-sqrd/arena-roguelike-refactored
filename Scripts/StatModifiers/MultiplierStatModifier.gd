class_name MultiplierStatModifier extends StatModifier


func _init(stat_id : StringName, value_provider : ValueProvider):
	self.stat_id = stat_id
	self.value_provider = value_provider
	pass
	

func apply_modifier(stat : Stat, context : Dictionary[StringName, Variant] = {}):
	_value = value_provider.get_value()
	stat.add_multiplier(_value)
	pass

func remove_modifier(stat : Stat, context : Dictionary = {}):
	stat.add_multiplier(-_value)
	pass
