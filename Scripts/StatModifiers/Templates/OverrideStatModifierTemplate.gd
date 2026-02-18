class_name OverrideStatModifierTemplate extends StatModifierTemplate


func build_modifier(context : Dictionary[StringName, Variant]) -> StatModifier:
	var override_modifier : OverrideStatModifier = OverrideStatModifier.new(stat_id, value_provider_template.build_value_provider(context))
	return override_modifier
