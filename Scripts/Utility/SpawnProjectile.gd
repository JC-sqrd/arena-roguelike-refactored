class_name SpawnProjectile extends RefCounted




static func spawn_projectile(projectile : Projectile, spawn_position : Vector2):
	projectile.global_position = spawn_position
	ProjectileServer.regiser_projectile(projectile.projectile_rid, projectile)
	projectile.draw_projectile()
