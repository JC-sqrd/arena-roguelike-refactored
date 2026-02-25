extends Node2D

const NORMAL_ENEMY = preload("uid://dkmv5cgdq0wh3")



func _ready() -> void:
	var max_x : float = - ((8000.0) /2)
	var max_y : float =  - ((8000.0) / 2)
	
	ArenaServer.active_arena = self
	
	for i in range(1000):
		var rand_pos : Vector2 = Vector2(randf_range(0, max_x), randf_range(0, max_y))
		var enemy : EnemyController = NORMAL_ENEMY.instantiate() as EnemyController
		enemy.global_position = rand_pos
		add_child(enemy)
		pass
	
	get_tree().create_timer(60).timeout.connect(spawn_enemes)
	
	pass


func spawn_enemes():
	
	var max_x : float = - ((8000.0) /2)
	var max_y : float =  - ((8000.0) / 2)
	
	for i in range(500):
		var rand_pos : Vector2 = Vector2(randf_range(0, max_x), randf_range(0, max_y))
		var enemy : EnemyController = NORMAL_ENEMY.instantiate() as EnemyController
		enemy.global_position = rand_pos
		add_child(enemy)
	
	get_tree().create_timer(60).timeout.connect(spawn_enemes)
	pass
