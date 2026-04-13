class_name EnemyWaveSpawn extends WaveSpawn

@export var enemy_scene : PackedScene


func instantiate_spawn() -> EnemyController:
	return enemy_scene.instantiate() as EnemyController
