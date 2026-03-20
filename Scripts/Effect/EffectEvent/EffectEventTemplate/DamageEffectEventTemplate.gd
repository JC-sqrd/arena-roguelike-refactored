class_name DamageEffectEventTemplate extends EffectEventTemplate



func build_effect_event(effect : Effect) -> DamageEffectEvent:
	var damage_event : DamageEffectEvent = DamageEffectEvent.new()
	if effect.mutator.stat_id == &"current_health":
		damage_event.damage_amount += effect.mutator.get_value()
		pass
	return damage_event
