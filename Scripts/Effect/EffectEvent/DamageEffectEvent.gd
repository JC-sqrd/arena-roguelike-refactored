class_name DamageEffectEvent extends EffectEvent

var damage_amount : float = 0

func invoke_event(context : Dictionary[StringName, Variant] = {}):
	var source : WeakRef = weakref(context.get("source"))
	var target_id : RID = context.get("target_rid")
	var target : Entity
	if EntityServer.active_entities.has(target_id):
		target = EntityServer.active_entities[target_id]
		EventServer.damage_event.emit(damage_amount, EntityServer.active_entities[target_id], context.get("source"), context)
	print("DAMAGE SOURCE: " + str(source))
	print("DAMAGE AMOUNT: " + str(damage_amount))
	print("DAMAGE TARGET: " + str(target))
	#EventServer.effect_event_occured.emit(self)
	pass
