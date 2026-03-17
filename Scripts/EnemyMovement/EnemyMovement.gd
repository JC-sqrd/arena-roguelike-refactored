class_name EnemyMovement extends Node

var enemy_entity : Entity
var enemy_controller : EnemyController

var velocity : Vector2
var move_speed_stat : Stat

func initialize(entity : Entity, controller : EnemyController):
	enemy_entity = entity
	move_speed_stat = enemy_entity.stats.get_stat("move_speed")
	enemy_controller = controller
	pass

func update_position(delta : float):
	
	pass
