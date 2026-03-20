class_name InstantEffectTemplate extends EffectTemplate

@export var effect_id : StringName = "instant_effect"
@export var flat_mutator_template : FlatStatMutatorTemplate

func build_effect(context : Dictionary[StringName, Variant]) -> Effect:
	#var mutator_templates : = flat_modifiers + mult_modifiers + override_modifiers
	var mutator : StatMutator
	#for mutator_template in flat_mutator_templates:
	mutator = (flat_mutator_template.build_mutator(context))
	#var modifiers : Array[StatModifier]
	#for template : StatModifierTemplate in modifier_templates:
	#	modifiers.append(template.build_modifier(context))
	var instant_effect : InstantEffect = InstantEffect.new(mutator)
	instant_effect.effect_id = effect_id
	instant_effect.effect_context = context
	instant_effect.applied_tags = applied_tags
	instant_effect.block_tags = block_tags
	instant_effect.effect_events = effect_event_templates
	return instant_effect
