class_name DelaySpawner extends AnimatedSprite2D

var delay : float = 1
@export var timer : Timer
var target : Vector2
var spawn : SpawnData
var spawn_position : Vector2

signal enemy_spawned(enemy : EnemyController, spawn_data : SpawnData)

func _ready() -> void:
	timer.timeout.connect(_on_timeout)
	timer.start(delay)
	pass

func _on_timeout():
	var enemy : EnemyController = spawn.instantiate_spawn() 
	enemy._target = target
	enemy.global_position = spawn_position
	ArenaServer.active_arena.add_child(enemy)
	enemy.area_controller.area.set_global_position(spawn_position)
	enemy.enemy_entity.entity.global_position = spawn_position
	enemy_spawned.emit(enemy, spawn)
	queue_free()
	pass
