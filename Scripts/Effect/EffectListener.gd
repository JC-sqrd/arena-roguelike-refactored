class_name EffectListener extends RefCounted



var stats : Stats
var entity : Entity

var durational_effects : Dictionary[StringName,DurationalEffect]

func _init(entity : Entity):
	self.entity = entity
	self.stats = entity.stats
	pass

func receive_effect(effect : Effect):
	if effect is InstantEffect:
		effect.apply_effect(entity)
		effect.invoke_effect_events()
		EventServer.effect_applied.emit(entity.entity_rid, effect, effect.effect_context)
		#effect.cleanup()
	elif effect is DurationalEffect:
		effect.effect_expired.connect(_on_durational_effect_expired)
		if effect.stackable and durational_effects.has(effect.effect_id):
			effect.stack += 1
		elif !durational_effects.has(effect.effect_id) and is_instance_valid(entity):
			effect.apply_effect(entity)
			effect.invoke_effect_events()
			durational_effects[effect.effect_id] = effect 
		EventServer.effect_applied.emit(entity.entity_rid, effect, effect.effect_context)
	pass

func update_durational_effects(delta : float):
	if durational_effects.is_empty():
		return
	
	for effect in durational_effects:
		durational_effects[effect].update(delta)
	pass

func _on_durational_effect_expired(effect : DurationalEffect):
	effect.remove_effect(entity)
	#effect.cleanup()
	durational_effects.erase(effect.effect_id)
	pass

func cleanup():
	stats.cleanup()
	stats = null
	entity = null
	pass
