extends ProjectileAttackExecute

@export var burst_count: int = 3
@export var delay_timer : Timer

func execute():
	generate_execute_context()
	var context : Dictionary[StringName, Variant] = controller.controller_context
	executing = true
	for i in range(burst_count):
		delay_timer.start()
		await delay_timer.timeout
		var projectile : Projectile = context.projectile_template.build_projectile()
		projectile.projectile_hit.connect(_on_projectile_hit)
		projectile.direction = (context.controller.get_global_mouse_position() - context.controller.global_position).normalized()
		projectile.angle = projectile.direction.angle()
		projectile.texture_angle = projectile.direction.angle()
		SpawnProjectile.spawn_projectile(projectile, context.controller.action_point.global_position)
	executing = false
	pass

func finish_execute():
	pass

func _on_projectile_hit(hit : RID):
	projectile_hit.emit(hit)
	pass
