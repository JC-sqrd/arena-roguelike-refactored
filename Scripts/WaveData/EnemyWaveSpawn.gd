class_name EnemyWaveSpawn extends WaveSpawn

@export var enemy_scene : PackedScene

func instantiate_spawn() -> EnemyController:
	var enemy_contoller : EnemyController = enemy_scene.instantiate() as EnemyController
	return enemy_contoller
