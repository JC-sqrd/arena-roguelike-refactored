extends Node


const tile_size : Vector2i = Vector2i(300, 300)

var active_enemies : Dictionary[int, EnemyController]

var active_cells : Dictionary[Vector2i, EnemyCellBucket]

var free_queue : Array[int]

var _keys : Array[int]

func _physics_process(delta: float) -> void:
	
	for enemy in free_queue:
		if active_enemies.has(enemy):
			var controller : EnemyController = active_enemies.get(enemy)
			controller.queue_free()
			free_enemy(enemy)
		free_queue.erase(enemy)
		pass
	
	_keys.clear()
	_keys = active_enemies.keys()
	
	for key in _keys:
		if active_enemies.has(key):
			var controller : EnemyController = active_enemies.get(key)
			controller.update_cell_coords(delta)
			controller.update_position(delta)
	pass


func register_enemy(id : int, enemy_controller : EnemyController):
	active_enemies[id] = enemy_controller
	pass


func update_cell_coords(cell_coords : Vector2i, enemy_controller : EnemyController):
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
	update_cell_coords(new_cell_coords, enemy_controller)
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

func get_active_enemies() -> int:
	return active_enemies.size()

func free_enemy(id : int):
	active_enemies.erase(id)
	pass

func to_free(id : int):
	free_queue.append(id)
