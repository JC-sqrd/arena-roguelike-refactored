class_name ProjectileMovement extends RefCounted

var projectile : Projectile

func initialize(projectile : Projectile):
	self.projectile = projectile



func update_movement(delta : float):
	projectile.velocity = projectile.direction * projectile.speed * delta
	projectile.global_position += projectile.velocity
	
	var xForm : Transform2D = Transform2D(projectile.angle, projectile.global_position)
	PhysicsServer2D.area_set_transform(projectile.projectile_rid, xForm)
	pass
