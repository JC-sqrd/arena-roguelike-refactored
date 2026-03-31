class_name ProjectileMovement extends Resource

@export var speed : float = 300
@export var range : float = 128

var _range_counter : float = 0

var projectile : Projectile

func initialize(projectile : Projectile):
	projectile.initialized.connect(_on_projectile_initialized)
	projectile.range = range
	projectile.speed = speed
	self.projectile = projectile

func _on_projectile_initialized():
	
	pass

func update_movement(delta : float):
	var frame_distance : float = speed * delta
	projectile.velocity = projectile.direction * frame_distance
	projectile.global_position += projectile.velocity
	_range_counter += frame_distance
	var xForm : Transform2D = Transform2D(projectile.angle, projectile.global_position)
	PhysicsServer2D.area_set_transform(projectile.projectile_rid, xForm)
	
	if _range_counter >= (range):
		projectile.active = false
		ProjectileServer.to_free(projectile.projectile_rid)
		pass
	pass

func free_rids():
	
	pass
