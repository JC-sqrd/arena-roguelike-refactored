class_name MultiplierStatModifierTemplate extends StatModifierTemplate


func build_modifier(context : Dictionary[StringName, Variant]) -> StatModifier:
	var mult_modifier : MultiplierStatModifier = MultiplierStatModifier.new(stat_id, value_provider_template.build_value_provider(context))
	return mult_modifier
