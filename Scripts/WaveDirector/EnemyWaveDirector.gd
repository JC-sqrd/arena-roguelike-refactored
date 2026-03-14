class_name EnemyWaveDirector extends WaveDirector

@export var wave_timer : Timer

signal wave_end()

var _total_wave_weight : float = 0
var _curr_wave_data :  EnemyWaveData

func start_wave(wave_data : EnemyWaveData):
	
	print("STARTED WAVE")
	_curr_wave_data = wave_data
	_total_wave_weight = calculate_wave_weight(wave_data)
	wave_data.current_wave_time = wave_data.wave_duration
	
	
	wave_timer.timeout.connect(_on_wave_timeout)
	wave_timer.start(1)
	pass

func _on_wave_timeout():
	print("SPAWN WAVE: " + str(_curr_wave_data.current_wave_time))
	spawn_wave()
	_curr_wave_data.current_wave_time -= 1
	
	if _curr_wave_data.current_wave_time <= 0:
		wave_timer.stop()
		wave_end.emit()
	pass

func spawn_wave():
	var pick : EnemyWaveSpawn = weighted_pick(_curr_wave_data.wave_spawns)
	
	if _curr_wave_data.wave_budget >= pick.spawn_cost:
		_curr_wave_data.wave_budget -= pick.spawn_cost
		var enemy : EnemyController = pick.instantiate_enemy()
		enemy.global_position = Vector2.ZERO
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
