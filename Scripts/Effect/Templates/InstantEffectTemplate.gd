class_name InstantEffectTemplate extends EffectTemplate

@export var effect_id : StringName = "instant_effect"
@export var flat_mutator_template : FlatStatMutatorTemplate

func build_effect(context : Dictionary[StringName, Variant]) -> Effect:
	var mutator : StatMutator
	mutator = (flat_mutator_template.build_mutator(context))
	var instant_effect : InstantEffect = InstantEffect.new(mutator)
	instant_effect.effect_id = effect_id
	instant_effect.effect_context = context
	instant_effect.applied_tags = applied_tags
	instant_effect.block_tags = block_tags
	for effect_event_template in effect_event_templates:
		instant_effect.effect_events.append(effect_event_template.duplicate_effect_event_template(true))
	return instant_effect
