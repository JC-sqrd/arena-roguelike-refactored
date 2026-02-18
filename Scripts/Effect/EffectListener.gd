class_name EffectListener extends RefCounted



var stats : Stats

func _init(stats : Stats):
	self.stats = stats
	pass

func receive_effect(effect : Effect, context : Dictionary[StringName,Variant]):
	effect.apply_effect(stats, context)
	pass
