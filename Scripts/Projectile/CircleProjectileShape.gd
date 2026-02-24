class_name CircleProjectileShape extends ProjectileShape

@export var radius = 16

var _shape_rid : RID

func set_projectile_shape(projectile : Projectile):
	_shape_rid = PhysicsServer2D.circle_shape_create()
	projectile.shape_rid = _shape_rid
	PhysicsServer2D.shape_set_data(_shape_rid, radius)
	PhysicsServer2D.area_add_shape(projectile.projectile_rid, _shape_rid)
	pass
