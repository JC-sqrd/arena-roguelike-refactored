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
	pass

func cleanup():
	stats.cleanup()
	stats = null
	pass
