class_name ProjectileAttackExecute extends AttackExecute

signal projectile_hit(hit : RID)

func initialize():
	
	pass

func execute(context : Dictionary[StringName, Variant]):
	var projectile : Projectile = context.projectile_template.build_projectile()
	projectile.projectile_hit.connect(_on_projectile_hit)
	projectile.direction = (context.controller.get_global_mouse_position() - context.controller.global_position).normalized()
	projectile.angle = projectile.direction.angle()
	projectile.texture_angle = projectile.direction.angle()
	SpawnProjectile.spawn_projectile(projectile, context.controller.action_point.global_position)
	pass

func finish_execute():
	pass

func _on_projectile_hit(hit : RID):
	projectile_hit.emit(hit)
	pass
