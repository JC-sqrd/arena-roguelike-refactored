class_name KnockbackEffectEventTemplate extends EffectEventTemplate

@export var magnitude : ValueProviderTemplate

var magnitude_value_provider : ValueProvider

func build_effect_event(effect : Effect) -> EffectEvent:
	if magnitude == null:
		magnitude = FlatValueProviderTemplate.new()
		magnitude.value = 10
		magnitude_value_provider = magnitude.build_value_provider(effect.effect_context)
	else:
		magnitude_value_provider = magnitude.build_value_provider(effect.effect_context)
	
	var knockback_event : KnockbackEffectEvent = KnockbackEffectEvent.new()
	knockback_event.magnitude = magnitude_value_provider.get_value(effect.effect_context)
	return knockback_event
