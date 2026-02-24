extends Node2D

var active_projectiles : Dictionary[RID, Projectile]


func regiser_projectile(rid : RID, projectile : Projectile):
	active_projectiles[rid] = projectile
	pass


func _physics_process(delta: float) -> void:
	if active_projectiles.size() == 0:
		return
	
	for active_projectile in active_projectiles:
		var projectile : Projectile = active_projectiles[active_projectile]
		if !projectile.active:
			continue
		projectile.process_projectile(delta)

func free_projectile(rid : RID):
	active_projectiles.erase(rid)
