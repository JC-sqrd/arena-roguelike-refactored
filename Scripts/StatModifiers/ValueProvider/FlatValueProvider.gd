class_name FlatValueProvider extends ValueProvider

var value : float = 0



func _init(value : float = 0, bonus_values : Array[BonusValue] = []):
	self.value = value
	self.bonus_values = bonus_values
	pass

func add_bonus_value(bonus_value : BonusValue):
	bonus_values.append(bonus_value)

func get_value(context : Dictionary[StringName, Variant] = {}) -> float:
	return value + calculate_bonus_value(value, context)

func calculate_bonus_value(value, context : Dictionary[StringName, Variant] = {}) -> float:
	var bonus_value : float = 0
	for bonus in bonus_values:
		bonus_value += bonus.get_bonus_value(value, context)
		pass
	return bonus_value
