class_name EffectListener extends RefCounted



var stats : Stats

var status_effects : Array[StatusEffect]

func _init(stats : Stats):
	self.stats = stats
	pass

func receive_effect(effect : Effect):
	effect.apply_effect(stats)
	pass

func receive_status_effect(status_effect : StatusEffect):
	status_effect.effect_expire.connect(_on_status_effect_expired)
	status_effect.apply_effect(stats)
	status_effects.append(status_effect)
	EffectServer.register_status_effect(status_effect)
	pass

func _on_status_effect_expired(status_effect : StatusEffect):
	status_effects.erase(status_effect)
	pass

func cleanup():
	stats.cleanup()
	stats = null
	pass
