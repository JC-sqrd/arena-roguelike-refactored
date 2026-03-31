class_name FollowTarget extends EnemyMovement

@export var target_distance_threshold : float = 30
var _distance_to_target : float
var _dir_to_target : Vector2
var _curr_cell_coords : Vector2i = Vector2i.ZERO
var _new_cell_coords : Vector2i = Vector2i.ZERO
var _separation_radius : float = 32
var _separation_force : float = 30

var target : Vector2 

func set_target(target : Vector2):
	self.target = target

func update_position(delta : float) -> Vector2: 
	#global_position = enemy_entity.entity.global_position
	
	if _distance_to_target <= target_distance_threshold:
		enemy_entity.velocity = Vector2.ZERO
		pass
	
	if PlayerServer.main_player == null:
		return Vector2.ZERO
	target = PlayerServer.main_player.global_position
	
	#Update velocity and push vector
	_dir_to_target = (target - enemy_entity.global_position).normalized()
	_distance_to_target = (target - enemy_entity.global_position).length()
	#enemy_entity.velocity = (_dir_to_target + _calculate_soft_collisions()) * move_speed_stat.get_value() * delta
	if active:
		enemy_entity.velocity = _dir_to_target * move_speed_stat.get_value() 
	
	enemy_entity.velocity *= delta
	enemy_entity.global_position += enemy_entity.velocity
	return enemy_entity.global_position


func update_cell_coords(delta : float):
	#Update cell coordinates
	_new_cell_coords = _calculate_new_cell_coords()
	if _new_cell_coords != _curr_cell_coords:
		EnemyServer.move_to_cell(_curr_cell_coords, _new_cell_coords, enemy_controller)
		_curr_cell_coords = _new_cell_coords
		pass
	pass

func _calculate_new_cell_coords() -> Vector2i:
	return Vector2i(floori( enemy_entity.global_position.x / EnemyServer.tile_size.x), floori( enemy_entity.global_position.y / EnemyServer.tile_size.y))

func get_current_cell_coords() -> Vector2i:
	return _curr_cell_coords

func _calculate_soft_collisions() -> Vector2:
	var push_vector : Vector2 = Vector2.ZERO
	var curr_cell : Vector2i = get_current_cell_coords()
	
	var neighbors : Array[EnemyController] = EnemyServer.get_nearby_enemies(curr_cell)
	
	for neighbor in neighbors:
		if neighbor == self:
			continue
		
		var dist_sq : float = enemy_entity.global_position.distance_squared_to(neighbor.global_position)
		var soft_radius_sq = _separation_radius**2
		
		if dist_sq < soft_radius_sq and dist_sq > 0.01:
			var diff : Vector2 = enemy_entity.global_position - neighbor.global_position
			var dist : float = sqrt(dist_sq)
			
			var strength : float = (_separation_radius - dist) / _separation_radius
			push_vector += (diff / dist) * strength * _separation_force
			pass
		pass
	
	return push_vector
