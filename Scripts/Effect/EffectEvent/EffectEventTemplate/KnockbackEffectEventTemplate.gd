class_name KnockbackEffectEventTemplate extends EffectEventTemplate

@export var magnitude : float = 10

func build_effect_event(effect : Effect) -> EffectEvent:
	var knockback_event : KnockbackEffectEvent = KnockbackEffectEvent.new()
	knockback_event.magnitude = magnitude
	return knockback_event
