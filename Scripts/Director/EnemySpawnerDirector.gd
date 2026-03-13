class_name EnemySpawnerDirector extends Node

var spawn_budget : float = 500

@export var spawn_pool : Dictionary[float, EnemySpawnData]

func get_spawn() -> Array[EnemyController]:
	
	return []
