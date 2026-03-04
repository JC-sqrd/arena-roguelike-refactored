class_name HitBox extends Area2D


@export var anim_player : AnimationPlayer
var effects : Array[Effect]
var context : Dictionary[StringName, Variant]


var active : bool = false

func _ready() -> void:
	monitorable = false
	collision_layer = 0
	collision_mask = 0

func initialize():
	active = true
	pass

func query_hitbox():
	
	var space_state : = get_world_2d().direct_space_state
		
	var hits : Dictionary[RID, bool]
	
	for child in self.get_children():
		if child is CollisionShape2D:
			var query : PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
			query.shape_rid = child.shape.get_rid()
			query.transform = child.global_transform
			query.collision_mask = collision_mask
			query.collide_with_areas = true
				
			var results = space_state.intersect_shape(query, 500)
				
			for result in results:
				hits[result.rid] = true
				pass
				
			pass
		
	for hit in hits.keys():
		for effect in effects:
			EffectServer.receive_effect(hit, effect, context)
	pass
