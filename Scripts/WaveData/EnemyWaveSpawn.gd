class_name EnemyWaveSpawn extends WaveSpawn

@export var enemy_scene : PackedScene


func instantiate_enemy() -> EnemyController:
	return enemy_scene.instantiate() as EnemyController
