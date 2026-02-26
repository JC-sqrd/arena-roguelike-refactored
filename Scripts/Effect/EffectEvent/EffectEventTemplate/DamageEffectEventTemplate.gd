class_name DamageEffectEventTemplate extends EffectEventTemplate


func build_effect_event(effect : Effect) -> DamageEffectEvent:
	var damage_event : DamageEffectEvent = DamageEffectEvent.new()
	for mutator in effect.mutators:
		if mutator.stat_id == &"current_health":
			damage_event.damage_amount += mutator.get_value()
			pass
		pass
	print("Damage Effect Event Total Damage: " + str(damage_event.damage_amount) )
	return damage_event
	
