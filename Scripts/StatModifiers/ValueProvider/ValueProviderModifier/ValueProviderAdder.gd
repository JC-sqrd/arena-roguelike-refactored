class_name ValueAdder extends Resource

@export var value : float = 0

func get_value(context : Dictionary[StringName, Variant]) -> float:
	return value
