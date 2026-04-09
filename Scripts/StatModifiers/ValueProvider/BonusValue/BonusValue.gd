class_name BonusValue extends Resource


@export var multipliers : Array[ValueMultiplier]
@export var adders : Array[ValueAdder]

func get_bonus_value(value : float, context : Dictionary[StringName, Variant]) -> float:
	return 0

func calculate_total_multiplier(context : Dictionary[StringName, Variant]) -> float:
	var total_multiplier : float = 1
	for multiplier in multipliers:
		total_multiplier += multiplier.get_value(context)
		pass
	return total_multiplier

func calculate_total_adder(context : Dictionary[StringName, Variant]) -> float:
	var total_adder : float = 0
	for adder in adders:
		total_adder += adder.get_value(context)
		pass
	return total_adder
