class_name StatValueProvider extends ValueProvider


var stat : Stat

func _init(stat : Stat = null, bonus_values : Array[BonusValue] = []):
	self.stat = stat
	self.bonus_values = bonus_values
	pass

func get_value(context : Dictionary[StringName, Variant] = {}) -> float:
	return stat.get_value() + calculate_bonus_value(stat.get_value(), context)
