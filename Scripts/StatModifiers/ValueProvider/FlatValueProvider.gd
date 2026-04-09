class_name FlatValueProvider extends ValueProvider

var value : float = 0



func _init(value : float = 0, bonus_values : Array[BonusValue] = [], multipliers : Array[ValueMultiplier] = [], adders : Array[ValueAdder] = []):
	self.value = value
	self.bonus_values = bonus_values
	self.multipliers = multipliers
	self.adders = adders
	pass

func add_bonus_value(bonus_value : BonusValue):
	bonus_values.append(bonus_value)

func get_value(context : Dictionary[StringName, Variant] = {}) -> float:
	var final_value : float = value + calculate_bonus_value(value, context)
	final_value += calculate_total_adder(context)
	final_value *= calculate_total_multiplier(context)
	return final_value

func calculate_bonus_value(value, context : Dictionary[StringName, Variant] = {}) -> float:
	var bonus_value : float = 0
	for bonus in bonus_values:
		bonus_value += bonus.get_bonus_value(value, context)
		pass
	return bonus_value
