class_name EnemyCellBucket extends RefCounted


var bucket : Array[EnemyController]


func append(enemy_controller : EnemyController):
	bucket.append(enemy_controller)
	pass


func has(enemy_controller : EnemyController) -> bool:
	return bucket.has(enemy_controller)

func erase(enemy_controller : EnemyController):
	bucket.erase(enemy_controller)

func size() -> int:
	return bucket.size()

func get_bucket() -> Array[EnemyController]:
	return bucket
