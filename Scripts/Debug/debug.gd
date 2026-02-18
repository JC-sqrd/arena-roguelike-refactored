extends Node2D

const NORMAL_ENEMY = preload("uid://dkmv5cgdq0wh3")



func _ready() -> void:
	var max_x : int = 5000
	var max_y : int = 5000
	
	for i in range(900):
		var rand_pos : Vector2 = Vector2(randi_range(0, max_x), randi_range(0, max_y))
		var enemy : EnemyController = NORMAL_ENEMY.instantiate() as EnemyController
		enemy.global_position = rand_pos
		add_child(enemy)
		pass
	pass
