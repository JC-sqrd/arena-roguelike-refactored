class_name EnemySpawnData extends SpawnData

@export var enemy_scene : PackedScene
var target : Vector2 


func instantiate_enemy() -> EnemyController:
	var enemy_controller : EnemyController = enemy_scene.instantiate() as EnemyController
	enemy_controller._target = target
	return enemy_controller
