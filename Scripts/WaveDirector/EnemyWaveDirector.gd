class_name EnemyWaveDirector extends WaveDirector

@export var wave_timer : Timer

signal wave_end()

var _total_wave_weight : float = 0
var _curr_wave_data :  EnemyWaveData

var wave_enemies : Array[EnemyController]

func start_wave(wave_data : EnemyWaveData):
	
	print("STARTED WAVE")
	_curr_wave_data = wave_data
	_total_wave_weight = calculate_wave_weight(wave_data)
	_curr_wave_data.curr_budget = _curr_wave_data.wave_budget
	wave_data.current_wave_time = wave_data.wave_duration
	
	
	wave_timer.timeout.connect(_on_wave_timeout)
	wave_timer.start(1)
	pass

func _on_wave_timeout():
	print("SPAWN WAVE: " + str(_curr_wave_data.current_wave_time))
	spawn_wave()
	_curr_wave_data.current_wave_time -= 1
	_curr_wave_data.curr_budget += _curr_wave_data.budget_gain
	
	if _curr_wave_data.current_wave_time <= 0:
		_curr_wave_data.curr_budget = 0
		free_wave_enemies()
		wave_timer.stop()
		wave_end.emit()
	pass

func spawn_wave():
	
	while _curr_wave_data.curr_budget > 0:
		
		var pick : EnemyWaveSpawn = weighted_pick(_curr_wave_data.wave_spawns)
		
		if _curr_wave_data.curr_budget >= pick.spawn_cost:
			_curr_wave_data.curr_budget -= pick.spawn_cost
			var enemy : EnemyController = pick.instantiate_enemy()
			var arena_size : Vector2 = (ArenaServer.active_arena.main_tilemap_layer.get_used_rect().size) * ArenaServer.active_arena.main_tilemap_layer.tile_set.tile_size 
			var arena_rect_pos : Vector2 = (ArenaServer.active_arena.main_tilemap_layer.get_used_rect().position * ArenaServer.active_arena.main_tilemap_layer.tile_set.tile_size)
			var rand_pos : Vector2 = Vector2(randf_range(arena_rect_pos.x, arena_rect_pos.x + (arena_size.x)), randf_range(arena_rect_pos.y, arena_rect_pos.y + (arena_size.y)))
			var tile_size : Vector2i = ArenaServer.active_arena.main_tilemap_layer.tile_set.tile_size
			var used_cells : Array[Vector2i] = ArenaServer.active_arena.main_tilemap_layer.get_used_cells()
			var rand_cell : Vector2i = used_cells[randi_range(0, used_cells.size()-1)] 
			var rand_offset : Vector2i = Vector2i(randi_range(0, tile_size.x), randi_range(0, tile_size.y))
			enemy.global_position = (rand_cell * tile_size) + rand_offset #rand_pos
			wave_enemies.append(enemy)
			ArenaServer.active_arena.add_child(enemy)
		pass
	pass

func weighted_pick(spawns : Array[EnemyWaveSpawn]) -> EnemyWaveSpawn:
	var total_weight : float = 0
	for spawn in spawns:
		total_weight += spawn.weight
	
	var rand : float = randf_range(0, total_weight)
	
	for spawn in spawns:
		rand -= spawn.weight
		if rand <= 0:
			return spawn
	return null

func get_min_spawn_cost() -> float:
	return 0

func calculate_wave_weight(wave_data : EnemyWaveData) -> float:
	var total_weight : float = 0 
	for spawn in wave_data.wave_spawns:
		total_weight += spawn.weight
	return total_weight


func free_wave_enemies():
	for enemy in wave_enemies:
		if enemy != null:
			EnemyServer.to_free(enemy._id)
	wave_enemies.clear()
	pass
