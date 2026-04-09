class_name ValueMultiplier extends Resource

func _init(value : float = 0):
	self.value = value
	pass

@export var value : float = 0

func get_value(context : Dictionary[StringName, Variant]) -> float:
	return value
