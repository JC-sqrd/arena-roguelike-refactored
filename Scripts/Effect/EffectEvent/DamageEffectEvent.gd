class_name DamageEffectEvent extends EffectEvent

var damage_amount : float = 0

func invoke_event(context : Dictionary[StringName, Variant] = {}):
	var source : Variant = context.get("source")
	print("DAMAGE SOURCE: " + str(source))
	print("DAMAGE AMOUNT: " + str(damage_amount))
	EventServer.effect_event_occured.emit(self)
	pass
