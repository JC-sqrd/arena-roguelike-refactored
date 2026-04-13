class_name EnemySpawner extends AnimatedSprite2D

var delay : float = 1
var spawn : SpawnData
var spawn_position : Vector2

signal enemy_spawned(enemy : EnemyController, spawn_data : SpawnData)

func _ready() -> void:
	get_tree().create_timer(delay).timeout.connect(_on_timeout)
	
	pass

func _on_timeout():
	var enemy : EnemyController = spawn.instantiate_spawn() 
	enemy.global_position = spawn_position
	ArenaServer.active_arena.add_child(enemy)
	enemy_spawned.emit(enemy, spawn)
	queue_free()
	pass
