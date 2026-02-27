class_name DamageEffectEvent extends EffectEvent

var damage_amount : float = 0

func invoke_event(context : Dictionary[StringName, Variant] = {}):
	EventServer.effect_event_occured.emit(self)
	pass
