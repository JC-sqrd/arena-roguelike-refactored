@abstract
class_name ValueProviderTemplate extends Resource

@export var bonus_values : Array[BonusValue]

@abstract
func build_value_provider(context : Dictionary[StringName, Variant]) -> ValueProvider


#func build_value_provider(context : Dictionary[StringName, Variant]) -> ValueProvider:
	#return ValueProvider.new(value, bonus_values)
