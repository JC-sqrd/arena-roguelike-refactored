class_name EnemyMovement extends Node

var enemy_entity : Entity
var enemy_controller : EnemyController

var velocity : Vector2
var move_speed_stat : Stat

var active : bool = false

var _update_offset : int = 0
var _update_threshold : int = 1

func initialize(entity : Entity, controller : EnemyController):
	enemy_entity = entity
	move_speed_stat = enemy_entity.stats.get_stat("move_speed")
	enemy_controller = controller
	_update_offset = randi_range(1,3)
	active = true
	pass

func update_position(delta : float):
	
	pass

func _exit_tree() -> void:
	move_speed_stat = null
	enemy_entity = null
