class_name StatValueProviderTemplate extends ValueProviderTemplate

@export var stat_template : StatTemplate


func build_value_provider(context : Dictionary[StringName, Variant]) -> ValueProvider:
	return StatValueProvider.new(stat_template.build_stat(), bonus_values)
