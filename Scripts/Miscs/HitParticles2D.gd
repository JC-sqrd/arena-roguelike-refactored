class_name HitParticles2D extends GPUParticles2D

var entity_rid : RID

func initialize(rid : RID):
	entity_rid = rid
	EventServer.effect_hit.connect(_on_effect_hit)
	pass


func _on_effect_hit(rid : RID, effect : Effect, context : Dictionary[StringName, Variant]):
	if rid == entity_rid:
		emitting = true
		var source_pos : Vector2 = context.source.global_position
		
		pass
	pass

func get_component_name() -> StringName:
	return "hit_particle_2d"
