class_name LaserRayCast extends RayCast2D



func query_ray() -> RID:
	var space_state = get_world_2d().direct_space_state
	
	#var query = PhysicsRayQueryParameters2D.create(controller.action_point.global_position, target_pos)
	var query : PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(global_position, target_position)
	
	query.collision_mask = collision_mask
	query.collide_with_areas = true
	
	var result = space_state.intersect_ray(query)
	if !result.is_empty():
		return result.rid
	return RID()
