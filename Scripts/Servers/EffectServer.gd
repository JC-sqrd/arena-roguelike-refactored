extends Node

var effect_listeners : Dictionary[RID, EffectListener]



func register_effect_listener(rid : RID, effect_listener : EffectListener):
	effect_listeners[rid] = effect_listener
	pass

func receive_effect(rid : RID, effect : Effect, context : Dictionary[StringName,Variant]):
	var effect_listener : EffectListener = effect_listeners.get(rid)
	if effect_listener:
		effect_listener.receive_effect(effect, context)
		return
	printerr("No registered effect listener for: " + str(rid))
	return
