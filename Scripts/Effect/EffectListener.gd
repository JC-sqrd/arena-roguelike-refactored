class_name EffectListener extends RefCounted



var stats : Stats
var entity : Entity

var durational_effects : Array[DurationalEffect]

func _init(entity : Entity):
	self.entity = entity
	self.stats = entity.stats
	pass

func receive_effect(effect : Effect):
	if effect is InstantEffect:
		effect.apply_effect(stats)
		effect.invoke_effect_events()
		EventServer.effect_applied.emit(entity.entity_rid, effect, effect.effect_context)
		effect.cleanup()
	elif effect is DurationalEffect:
		effect.effect_expired.connect(_on_durational_effect_expired)
		effect.invoke_effect_events()
		durational_effects.append(durational_effects)
		EventServer.effect_applied.emit(entity.entity_rid, effect, effect.effect_context)
	pass

func update_durational_effects(delta : float):
	for effect in durational_effects:
		effect.update(delta)
	pass

func _on_durational_effect_expired(effect : Effect):
	effect.cleanup()
	durational_effects.erase(effect)
	pass

func cleanup():
	stats.cleanup()
	stats = null
	entity = null
	pass
