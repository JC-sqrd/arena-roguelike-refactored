class_name WeaponStatValueProviderTemplate extends ValueProviderTemplate

@export var stat_id : StringName

func build_value_provider(context : Dictionary[StringName, Variant]) -> ValueProvider:
	return WeaponStatValueProvider.new(stat_id, bonus_values)
