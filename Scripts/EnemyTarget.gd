class_name EnemyTarget extends Area2D


signal target_hit(entity : Entity, data:Dictionary[StringName, Variant])

func _physics_process(delta: float) -> void:
	var enemies : Array[RID] = query_enemies()
	for enemy_id in enemies:
		var enemy_entity : Entity = EntityServer.active_entities[enemy_id]
		var enemy : EnemyController = EnemyServer.active_enemies[enemy_entity.get_instance_id()]
		var hit_data : Dictionary[StringName, Variant] = {"enemy_controller":enemy}
		target_hit.emit(enemy_entity, hit_data)
		enemy.area_controller.free_area()
		enemy.active = false
		enemy.free_controller()
		pass
	pass



func query_enemies(max_results : int = 32) -> Array[RID]:
	var space_state : PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	
	var hits : Array[RID]
	
	var results : Array[Dictionary]
	
	for child in self.get_children():
		if child is CollisionShape2D:
			var query : PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
			query.shape_rid = child.shape.get_rid()
			query.transform = child.global_transform
			query.collision_mask = collision_mask
			query.collide_with_areas = true
			
			results = space_state.intersect_shape(query, max_results)
			
			for result in results:
				var result_rid : RID = result.rid
				hits.append(result_rid)
				pass
			pass
	return hits
