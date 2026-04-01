#Effect Server Singleton
extends Node

enum EffectEventTag {
	none,
	damage,
	lifesteal
}

var effect_listeners : Dictionary[RID, EffectListener]

var active_status_effects : Array[StatusEffect]
var status_effects_free_queue : Array[StatusEffect]

func register_effect_listener(rid : RID, effect_listener : EffectListener):
	effect_listeners[rid] = effect_listener
	pass

func register_status_effect(status_effect : StatusEffect):
	status_effect.effect_expire.connect(_on_status_effect_expire)
	active_status_effects.append(status_effect)
	pass

func _process(delta: float) -> void:
	if active_status_effects.is_empty():
		return
	
	for status_effect in status_effects_free_queue:
		if active_status_effects.has(status_effect):
			status_effect.cleanup()
			active_status_effects.erase(status_effect)
		pass
	
	for status_effect in active_status_effects:
		status_effect.update(delta)
		pass
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
		effect.cleanup()
		return
	printerr("No registered effect listener for: " + str(rid))
	return

func _on_status_effect_expire(status_effect : StatusEffect):
	status_effects_free_queue.append(status_effect)
	pass
