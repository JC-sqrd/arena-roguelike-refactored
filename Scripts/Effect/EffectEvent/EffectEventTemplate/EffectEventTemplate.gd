@abstract
class_name EffectEventTemplate extends Resource

@abstract
func build_effect_event(effect : Effect) -> EffectEvent

func get_effect_event_template_id() -> StringName:
	return ""

func duplicate_effect_event_template(deep : bool = false) -> EffectEventTemplate:
	return self.duplicate(deep)
