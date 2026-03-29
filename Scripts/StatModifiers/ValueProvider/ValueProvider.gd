@abstract
class_name ValueProvider extends RefCounted

var bonus_value : float = 0
var bonus_values : Array[BonusValue]

var multipliers : Array[ValueMultiplier]
var adders : Array[ValueAdder]


@abstract
func get_value(context : Dictionary[StringName, Variant] = {}) -> float

func add_bonus_value(bonus_value : BonusValue):
	bonus_values.append(bonus_value)

func calculate_bonus_value(value, context : Dictionary[StringName, Variant] = {}) -> float:
	var bonus_value : float = 0
	for bonus in bonus_values:
		bonus_value += bonus.get_bonus_value(value, context)
		pass
	return bonus_value

func calculate_total_multiplier() -> float:
	var total_multiplier : float = 1
	for multiplier in multipliers:
		total_multiplier += multiplier.value
		pass
	return total_multiplier

func calculate_total_adder() -> float:
	var total_adder : float = 0
	for adder in adders:
		total_adder += adder.value
		pass
	return total_adder

func cleanup():
	bonus_values.clear()
	multipliers.clear()
	adders.clear()
	pass
