class_name EnemyController extends Area2D

@export var enemy_entity : Entity

func _ready() -> void:
	enemy_entity.initalize(get_rid())
	pass
