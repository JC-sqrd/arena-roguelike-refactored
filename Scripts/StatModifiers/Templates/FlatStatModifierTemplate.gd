class_name FlatStatModifierTemplate extends StatModifierTemplate

@export var mode : FlatStatModifier.Mode = FlatStatModifier.Mode.ADD

func build_modifier(context : Dictionary[StringName, Variant]) -> StatModifier:
	var flat_modifier : FlatStatModifier = FlatStatModifier.new(stat_id, value_provider_template.build_value_provider(context), mode)
	return flat_modifier
