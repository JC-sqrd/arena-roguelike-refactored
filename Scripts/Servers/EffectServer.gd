#Effect Server Singleton
extends Node

var effect_listeners : Dictionary[RID, EffectListener]
var effect_queue : Array[Dictionary]
var service_arr : Array[Dictionary]

var start_time : float
var frame_budget : float = 5000 # 2 ms

func register_effect_listener(rid : RID, effect_listener : EffectListener):
	effect_listeners[rid] = effect_listener
	pass

func _process(delta: float) -> void:
	for listener in effect_listeners:
		effect_listeners[listener].update_durational_effects(delta)
		pass
	
	if effect_queue.is_empty():
		return
	
	start_time = Time.get_ticks_usec()
	
	while !effect_queue.is_empty():
		if Time.get_ticks_usec()- start_time > frame_budget:
			return
		var data : Dictionary[StringName, Variant] = effect_queue.pop_front()
		
		if data.has("batched"):
			var rids : Array[RID] = data.rids
			var effect : Effect = data.effect
			var context : Dictionary[StringName, Variant] = data.context
			for rid in rids:
				var effect_listener : EffectListener = effect_listeners.get(rid)
				if effect_listener != null:
					effect.effect_context = context
					effect.effect_context.target_rid = rid
					effect_listener.receive_effect(effect)
			#effect_queue.remove_at(i)
		else:
			var rid : RID = data.rid
			var effect_listener : EffectListener = effect_listeners.get(rid)
			var effect : Effect = data.effect
			var context : Dictionary[StringName, Variant] = data.context
			print("EFFECT CONTEXT: ",str(context))
			if effect_listener != null:
				effect.effect_context = context
				effect.effect_context.target_rid = rid
				effect_listener.receive_effect(effect)
			#effect_queue.remove_at(i)
		pass
func free_rid(rid : RID):
	effect_listeners.erase(rid)
	pass

func receive_effect_batched(rids : Array[RID], effect : Effect, context : Dictionary[StringName, Variant]):
	var data : Dictionary[StringName, Variant]
	data["rids"] = rids
	data["effect"] = effect
	data["context"] = context
	data["batched"] = true
	
	effect_queue.append(data)
	pass

func receive_effect(rid : RID, effect : Effect, context : Dictionary[StringName,Variant]):
	#var data : Dictionary[StringName, Variant]
	#data["rid"] = rid
	#data["effect"] = effect
	#data["context"] = context
	#
	#effect_queue.append(data)
	#return
	
	var effect_listener : EffectListener = effect_listeners.get(rid)
	print("EFFECT CONTEXT: ",str(context))
	if effect_listener != null:
		effect.effect_context = context
		effect.effect_context.target_rid = rid
		effect_listener.receive_effect(effect)
		#EventServer.effect_hit.emit(rid, effect, effect.effect_context)
		
	printerr("No registered effect listener for: " + str(rid))
	return
