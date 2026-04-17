#Effect Server Singleton
extends Node

var effect_listeners : Dictionary[RID, EffectListener]
var effect_queue : Array[Dictionary]
var service_arr : Array[Dictionary]

func register_effect_listener(rid : RID, effect_listener : EffectListener):
	effect_listeners[rid] = effect_listener
	pass

func _process(delta: float) -> void:
	for listener in effect_listeners:
		effect_listeners[listener].update_durational_effects(delta)
		pass
	
	if effect_queue.is_empty():
		return
	
	for i in range(6):
		if i >= effect_queue.size():
			return
		var rid : RID = effect_queue[i].rid
		var effect_listener : EffectListener = effect_listeners.get(rid)
		var effect : Effect = effect_queue[i].effect
		var context : Dictionary[StringName, Variant] = effect_queue[i].context
		print("EFFECT CONTEXT: ",str(context))
		if effect_listener != null:
			effect.effect_context = context
			effect.effect_context.target_rid = rid
			effect_listener.receive_effect(effect)
		effect_queue.remove_at(i)
		pass
func free_rid(rid : RID):
	effect_listeners.erase(rid)
	pass

func receive_effect(rid : RID, effect : Effect, context : Dictionary[StringName,Variant]):
	var data : Dictionary[StringName, Variant]
	data["rid"] = rid
	data["effect"] = effect
	data["context"] = context
	
	effect_queue.append(data)
	return
	
	var effect_listener : EffectListener = effect_listeners.get(rid)
	print("EFFECT CONTEXT: ",str(context))
	if effect_listener != null:
		effect.effect_context = context
		effect.effect_context.target_rid = rid
		effect_listener.receive_effect(effect)
		#EventServer.effect_hit.emit(rid, effect, effect.effect_context)
		
	printerr("No registered effect listener for: " + str(rid))
	return
