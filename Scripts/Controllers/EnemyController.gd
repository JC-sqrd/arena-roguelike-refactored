class_name EnemyController extends Area2D

@export var enemy_entity : Entity

func _ready() -> void:
	enemy_entity.initalize(get_rid())
	enemy_entity.health_manager.health_depleted.connect(_on_health_depleted)
	pass


func _on_health_depleted():
	queue_free()
	pass
