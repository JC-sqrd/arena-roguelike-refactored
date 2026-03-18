class_name HitBox extends Area2D


@export var anim_player : AnimationPlayer
var effects : Array[Effect]
var context : Dictionary[StringName, Variant]


var active : bool = false
var hit_log : Array[RID]

func _ready() -> void:
	monitorable = false

func initialize():
	active = true
	pass

func query_hitbox(log_hit : bool = false, hits_out : Array[RID] = []) -> Array[RID]:
	
	var space_state : = get_world_2d().direct_space_state
	
	var hits : Array[RID]
	
	var new_hits : Array[RID]
	
	var results : Array[Dictionary]
	
	for child in self.get_children():
		if child is CollisionShape2D:
			var query : PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
			query.shape_rid = child.shape.get_rid()
			query.transform = child.global_transform
			query.collision_mask = collision_mask
			query.collide_with_areas = true
				
			results = space_state.intersect_shape(query, 500)
				
			for result in results:
				var result_rid : RID = result.rid
				hits.append(result_rid)
				
				if !hit_log.has(result_rid):
					new_hits.append(result_rid)
				
				if log_hit:
					hit_log.append(result_rid)
					pass
				pass
			pass
	
	for hit in hit_log:
		if !hits.has(hit):
			hit_log.erase(hit)
			pass
		pass
	
	#print("HITBOX QUERIED: " + str(hits))
	
	for hit in new_hits:
		for effect in effects:
			EffectServer.receive_effect(hit, effect, context)
			EventServer.effect_hit.emit(hit, effect, context)
	hits_out = new_hits
	return new_hits
