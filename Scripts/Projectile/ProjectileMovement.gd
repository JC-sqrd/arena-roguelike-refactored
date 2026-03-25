class_name ProjectileMovement extends RefCounted

var projectile : Projectile

func initialize(projectile : Projectile):
	self.projectile = projectile



func update_movement(delta : float):
	var frame_distance : float = projectile.speed * delta
	projectile.velocity = projectile.direction * frame_distance
	projectile.global_position += projectile.velocity
	projectile._range_counter += frame_distance
	
	var xForm : Transform2D = Transform2D(projectile.angle, projectile.global_position)
	PhysicsServer2D.area_set_transform(projectile.projectile_rid, xForm)
	pass
