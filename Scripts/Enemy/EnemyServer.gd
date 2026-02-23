extends Node


const tile_size : Vector2i = Vector2i(300, 300)


var active_cells : Dictionary[Vector2i, EnemyCellBucket]

func register_enemy(cell_coords : Vector2i, enemy_controller : EnemyController):
	var bucket : EnemyCellBucket = active_cells.get(cell_coords)
	
	if bucket != null:
		bucket.append(enemy_controller)
	else:
		bucket = EnemyCellBucket.new()
		bucket.append(enemy_controller)
		active_cells[cell_coords] = bucket
	pass

func move_to_cell(curr_cell_coords : Vector2i, new_cell_coords : Vector2i, enemy_controller : EnemyController):
	free_from_cell(curr_cell_coords, enemy_controller)
	register_enemy(new_cell_coords, enemy_controller)
	pass

func free_from_cell(cell_coords : Vector2i, enemy_controller : EnemyController):
	var bucket : EnemyCellBucket = active_cells.get(cell_coords)
	
	if bucket != null:
		bucket.erase(enemy_controller)
		
		if bucket.size() == 0 and active_cells.has(cell_coords):
			active_cells.erase(cell_coords)
		pass
	pass

func get_nearby_enemies(center_cell : Vector2i) -> Array[EnemyController]:
	var nearby_enemies : Array[EnemyController] = []
	for x in range(-1, 2):
		for y in range(-1, 2):
			var target_cell : Vector2i = center_cell + Vector2i(x, y)
			var bucket : EnemyCellBucket = active_cells.get(target_cell)
			if bucket != null:
				nearby_enemies.append_array(bucket.get_bucket())
			pass
	return nearby_enemies
