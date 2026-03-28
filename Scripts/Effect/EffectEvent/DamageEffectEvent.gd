class_name DamageEffectEvent extends EffectEvent

var damage_amount : float = 0
var target : RID
var source : WeakRef

func invoke_event(context : Dictionary[StringName, Variant] = {}):
	source = weakref(context.get("source"))
	target = context.get("target_rid")
	print("DAMAGE SOURCE: " + str(source))
	print("DAMAGE AMOUNT: " + str(damage_amount))
	print("DAMAGE TARGET: " + str(EntityServer.active_entities[target]))
	EventServer.damage_effect_event_occured.emit(self)
	#EventServer.effect_event_occured.emit(self)
	pass
