extends Node

enum EffectEventTag {
	none,
	damage,
	lifesteal
}

var effect_listeners : Dictionary[RID, EffectListener]


func register_effect_listener(rid : RID, effect_listener : EffectListener):
	effect_listeners[rid] = effect_listener
	pass

func free_rid(rid : RID):
	effect_listeners.erase(rid)
	pass

func receive_effect(rid : RID, effect : Effect, context : Dictionary[StringName,Variant]):
	var effect_listener : EffectListener = effect_listeners.get(rid)
	if effect_listener:
		effect.effect_context = context
		effect.effect_context.target_rid = rid
		effect_listener.receive_effect(effect)
		EventServer.effect_hit.emit(rid, effect, effect.effect_context)
		effect.invoke_effect_events()
		#for event_template in effect.effect_events:
			#event_template.build_effect_event(effect).invoke_event()
		return
	printerr("No registered effect listener for: " + str(rid))
	return
