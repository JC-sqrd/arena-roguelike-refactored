class_name HitParticles2D extends GPUParticles2D

var entity_rid : RID

func initialize(rid : RID):
	entity_rid = rid
	EventServer.damage_event.connect(_on_damage_event_occured)
	pass

func _on_damage_event_occured(damage_amount : float, target : Entity, source : Entity, context : Dictionary[StringName, Variant]):
	if target.entity_rid == entity_rid:
		if emitting:
			restart()
		emitting = true
	pass

func _on_effect_applied(rid : RID, effect : Effect, context : Dictionary[StringName, Variant]):
	
	pass

func get_component_name() -> StringName:
	return "hit_particle_2d"

func _exit_tree() -> void:
	entity_rid = RID()
	EventServer.damage_event.disconnect(_on_damage_event_occured)
	pass
