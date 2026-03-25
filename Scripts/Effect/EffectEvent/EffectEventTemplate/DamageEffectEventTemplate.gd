class_name DamageEffectEventTemplate extends EffectEventTemplate


var event_id : StringName =  "damage_effect_event"

func build_effect_event(effect : Effect) -> DamageEffectEvent:
	var damage_event : DamageEffectEvent = DamageEffectEvent.new()
	damage_event.event_id = event_id
	if effect.mutator.stat_id == &"current_health":
		damage_event.damage_amount += effect.mutator.get_value()
		pass
	return damage_event

func get_effect_event_template_id() -> StringName:
	return event_id
