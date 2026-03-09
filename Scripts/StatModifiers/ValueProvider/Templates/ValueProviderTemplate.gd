@abstract
class_name ValueProviderTemplate extends Resource

@export var bonus_values : Array[BonusValue]
@export var multipliers : Array[ValueMultiplier]
@export var adders : Array[ValueAdder]

@abstract
func build_value_provider(context : Dictionary[StringName, Variant]) -> ValueProvider
