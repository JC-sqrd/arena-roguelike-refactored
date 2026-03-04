extends Node2D

const NORMAL_ENEMY = preload("uid://dkmv5cgdq0wh3")

func _ready() -> void:
	
	var max_x : float = - ((8000.0) /2)
	var max_y : float =  - ((8000.0) / 2)
	ArenaServer.active_arena = self
	
	spawn_enemy()
	
	for i in range(randi_range(500, 700)):
		spawn_enemy()
		if EnemyServer.active_enemies.size() >= 1500:
			break
		pass
	
	get_tree().create_timer(randi_range(30, 60)).timeout.connect(spawn_horde)
	pass


func spawn_enemy():
	
	var viewport_size : = get_viewport().get_visible_rect().size
	var camera_pos : = get_viewport().get_camera_2d().global_position
	
	var spawn_radius : float = (viewport_size / 2).length() + 1200
	var random_angle : float = randf() * TAU
	var spawn_offset : Vector2 = Vector2.from_angle(random_angle) * spawn_radius
	
	var max_x : float = - ((8000.0) /2)
	var max_y : float =  - ((8000.0) / 2)
	
	#var rand_pos : Vector2 = Vector2(randf_range(0, max_x), randf_range(0, max_y))
	var enemy : EnemyController = NORMAL_ENEMY.instantiate() as EnemyController
	enemy.global_position = camera_pos + spawn_offset#rand_pos
	add_child(enemy)
	
	get_tree().create_timer(60).timeout.connect(spawn_enemy)
	pass

func spawn_horde():
	
	for i in range(randi_range(50, 150)):
		if EnemyServer.active_enemies.size() >= 1500:
			break
		spawn_enemy()
		pass
	
	get_tree().create_timer(randi_range(30, 60)).timeout.connect(spawn_horde)
	pass
