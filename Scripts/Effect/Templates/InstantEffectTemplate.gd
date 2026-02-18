class_name InstantEffectTemplate extends EffectTemplate

@export var flat_mutator_templates : Array[FlatStatMutatorTemplate]

func build_effect(context : Dictionary[StringName, Variant]) -> Effect:
	#var mutator_templates : = flat_modifiers + mult_modifiers + override_modifiers
	var mutators : Array[StatMutator]
	for mutator_template in flat_mutator_templates:
		mutators.append(mutator_template.build_mutator(context))
	#var modifiers : Array[StatModifier]
	#for template : StatModifierTemplate in modifier_templates:
	#	modifiers.append(template.build_modifier(context))
	var instant_effect : InstantEffect = InstantEffect.new(mutators)
	instant_effect.applied_tags = applied_tags
	instant_effect.block_tags = block_tags
	return instant_effect
