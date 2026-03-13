class_name EnemySpawnData extends SpawnData

@export var enemy_scene : PackedScene



func instantiate_enemy() -> EnemyController:
	return enemy_scene.instantiate() as EnemyController
