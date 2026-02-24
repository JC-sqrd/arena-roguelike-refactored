extends Node2D

var active_projectiles : Dictionary[RID, Projectile]

var _keys : Array[RID]

var free_queue : Array[RID]

func regiser_projectile(rid : RID, projectile : Projectile):
	active_projectiles[rid] = projectile
	pass


func _physics_process(delta: float) -> void:
	if active_projectiles.size() == 0:
		return
	
	_keys = active_projectiles.keys()
	
	for key in _keys:
		if active_projectiles.has(key):
			active_projectiles[key].process_projectile(delta)
			pass
		pass
	
	for projectile in active_projectiles:
		active_projectiles[projectile].process_projectile(delta)
	
	for rid in free_queue:
		var projectile : Projectile = active_projectiles.get(rid)
		if projectile:
			free_projectile(rid)
			projectile.free_projectile()
		pass
	pass


func to_free(rid : RID):
	free_queue.append(rid)
	pass

func free_projectile(rid : RID):
	active_projectiles.erase(rid)
