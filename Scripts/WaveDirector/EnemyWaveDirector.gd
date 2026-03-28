class_name EnemyWaveDirector extends WaveDirector

@export var wave_timer : Timer

signal wave_end()

var _total_wave_weight : float = 0
var _curr_wave_data :  EnemyWaveData

var _leftover_budget : float = 0

var wave_enemies : Array[EnemyController]

var cost_dict : Dictionary[EnemyController, float]

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
	
	var arena_center : = ArenaServer.active_arena.main_tilemap_layer.get_used_rect().get_center() *  ArenaServer.active_arena.main_tilemap_layer.tile_set.tile_size 
	print("ARENA CENTER: " + str(arena_center))
	
	print("SPAWN WAVE: " + str(_curr_wave_data.current_wave_time))
	_curr_wave_data.current_wave_time -= 1
	var _leftover_spread : float = (_leftover_budget / _curr_wave_data.wave_duration)
	var budget_gain : float = (_curr_wave_data.budget_gain + _leftover_spread) 
	_curr_wave_data.curr_budget += budget_gain
	spawn_wave()
	
	if _curr_wave_data.current_wave_time <= 0:
		_leftover_budget = calculate_leftover_budget()
		_curr_wave_data.curr_budget = 0
		free_wave_enemies()
		wave_timer.stop()
		wave_end.emit()
	pass

func spawn_wave():
	
	print("ACTIVE ENEMIES: " + str(EnemyServer.active_enemies.size()))
	
	while _curr_wave_data.curr_budget > 0:
		
		var pick : EnemyWaveSpawn = weighted_pick(_curr_wave_data.wave_spawns)
		
		if EnemyServer.active_enemies.size() >= 1000:
			break
		
		var min_cost : float = get_min_spawn_cost(_curr_wave_data.wave_spawns)
		
		if _curr_wave_data.curr_budget < min_cost:
			break
		elif _curr_wave_data.curr_budget >= pick.spawn_cost:
			_curr_wave_data.curr_budget -= pick.spawn_cost
			var enemy : EnemyController = pick.instantiate_enemy()
			var tile_size : Vector2i = ArenaServer.active_arena.main_tilemap_layer.tile_set.tile_size
			var used_cells : Array[Vector2i] = ArenaServer.active_arena.main_tilemap_layer.get_used_cells()
			var rand_cell : Vector2i = used_cells[randi_range(0, used_cells.size()-1)] 
			var rand_offset : Vector2i = Vector2i(randi_range(0, tile_size.x), randi_range(0, tile_size.y))
			cost_dict[enemy] = pick.spawn_cost
			enemy.global_position = (rand_cell * tile_size) + rand_offset #rand_pos
			ArenaServer.active_arena.add_child(enemy)
			wave_enemies.append(enemy)
		else:
			break
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

func get_min_spawn_cost(spawns : Array[EnemyWaveSpawn]) -> float:
	var min : float = spawns[0].spawn_cost
	for spawn in spawns:
		min = min(min, spawn.spawn_cost)
	return min

func calculate_wave_weight(wave_data : EnemyWaveData) -> float:
	var total_weight : float = 0 
	for spawn in wave_data.wave_spawns:
		total_weight += spawn.weight
	return total_weight


func calculate_leftover_budget() -> float:
	var leftover_cost : float = 0
	for enemy in wave_enemies:
		if enemy == null:
			continue
		elif cost_dict.has(enemy):
			leftover_cost += cost_dict[enemy]
	cost_dict.clear()
	return leftover_cost

func free_wave_enemies():
	for enemy in wave_enemies:
		if enemy != null:
			#EnemyServer.to_free(enemy._id)
			enemy.active = false
			enemy.free_controller()
	wave_enemies.clear()
	pass
