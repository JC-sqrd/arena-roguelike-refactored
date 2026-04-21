#Effect Server Singleton
extends Node

var effect_listeners : Dictionary[RID, EffectListener]
var free_queue : Array[RID]
var hit_queue : Dictionary[RID, Array]
var effect_queue : Array[Dictionary]
var service_arr : Array[Dictionary]

var start_time : float
var frame_budget : float = 5000 # 5 ms

func register_effect_listener(rid : RID, effect_listener : EffectListener):
	effect_listeners[rid] = effect_listener
	pass

func _process(delta: float) -> void:
	for listener in effect_listeners:
		effect_listeners[listener].update_durational_effects(delta)
		pass
	
	if hit_queue.is_empty():
		return
	
	
	#for hit in free_queue:
	#	hit_queue.erase(hit)
	
	#free_queue.clear()
	
	#start_time = Time.get_ticks_usec()
	
	for hit in hit_queue:
		#if Time.get_ticks_usec()- start_time > frame_budget:
		#	return
		#var effect : Effect = hit_queue[hit][0] 
		var effect_listener : EffectListener = effect_listeners.get(hit)
		for i in range(hit_queue[hit].size()):
			if i >= 32:
				break
			var data : Array = hit_queue[hit][i]
			var context : Dictionary[StringName, Variant] = data[1]#hit_queue[hit][1]
			if effect_listener != null:
				data[0].effect_context = context
				data[0].effect_context.target_rid = hit
				effect_listener.receive_effect(data[0])
				EventServer.effect_hit.emit(hit, data[0], context)
				
		#free_queue.append(hit)
	
	hit_queue.clear()
	
	#if effect_queue.is_empty():
		#return
	#
	#if effect_queue.size() >= 100:
		#frame_budget = 10000
	#else:
		#frame_budget = 5000 
	#
	#start_time = Time.get_ticks_usec()
	#
	#while !effect_queue.is_empty():
		#if Time.get_ticks_usec()- start_time > frame_budget:
			#return
		#var data : Dictionary[StringName, Variant] = effect_queue.pop_front()
		#
		#if data.has("batched"):
			#var rids : Array[RID] = data.rids
			#var effect : Effect = data.effect
			#var context : Dictionary[StringName, Variant] = data.context
			#for rid in rids:
				#var effect_listener : EffectListener = effect_listeners.get(rid)
				#if effect_listener != null:
					#effect.effect_context = context
					#effect.effect_context.target_rid = rid
					#effect_listener.receive_effect(effect)
			##effect_queue.remove_at(i)
		#else:
			#var rid : RID = data.rid
			#var effect_listener : EffectListener = effect_listeners.get(rid)
			#var effect : Effect = data.effect
			#var context : Dictionary[StringName, Variant] = data.context
			#print("EFFECT CONTEXT: ",str(context))
			#if effect_listener != null:
				#effect.effect_context = context
				#effect.effect_context.target_rid = rid
				#effect_listener.receive_effect(effect)
			##effect_queue.remove_at(i)
		#pass
	pass

func free_rid(rid : RID):
	effect_listeners.erase(rid)
	pass


func receive_effect(rid : RID, effect : Effect, context : Dictionary[StringName,Variant]):
	
	#if effect_queue.size() >= 100:
		#effect_queue.pop_back()
		##return
	#
	#var data : Dictionary[StringName, Variant]
	#data["rid"] = rid
	#data["effect"] = effect
	#data["context"] = context
	#
	#effect_queue.append(data)
	if hit_queue.size() >= 100:
		hit_queue.erase(hit_queue.keys().pop_back()) 
		#return
	
	var hit_data : Array[Variant] = [effect, context]
	if hit_queue.has(rid):
		hit_queue[rid].append(hit_data)
		#return
	else:
		hit_queue[rid] = []
		hit_queue[rid].append(hit_data)
	return
	
	var effect_listener : EffectListener = effect_listeners.get(rid)
	if effect_listener != null:
		effect.effect_context = context
		effect.effect_context.target_rid = rid
		effect_listener.receive_effect(effect)
		#EventServer.effect_hit.emit(rid, effect, effect.effect_context)
		
	printerr("No registered effect listener for: " + str(rid))
	return
