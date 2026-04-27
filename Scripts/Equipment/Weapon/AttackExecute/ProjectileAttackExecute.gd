class_name ProjectileAttackExecute extends AttackExecute

var projectile_weapon_controller : ProjectileWeaponController
signal projectile_hit(hit : RID)


func initialize(controller : WeaponController):
	super(controller)
	projectile_weapon_controller = controller
	pass

func execute():
	generate_execute_context()
	executing = true
	var context : Dictionary[StringName, Variant] = controller.controller_context
	var projectile : Projectile = context.projectile_template.build_projectile()
	projectile.projectile_hit.connect(_on_projectile_hit)
	projectile.direction = (context.controller.get_global_mouse_position() - context.controller.global_position).normalized()
	projectile.angle = projectile.direction.angle()
	projectile.texture_angle = projectile.direction.angle()
	SpawnProjectile.spawn_projectile(projectile, context.controller.action_point.global_position)
	executing = false
	pass

func generate_execute_context():
	controller.controller_context = controller.generate_controller_context()
	var attack_effects : Array[Effect] = controller.generate_effects(controller.controller_context)
	
	controller.controller_context.wielder_stats = controller.wielder_stats
	controller.effects.clear()
	controller.effects = attack_effects
	controller.controller_context.effects_context = controller.controller_context
	controller.controller_context.queries = controller.queries
	controller.controller_context.weapon_stats = controller.weapon_stats
	controller.controller_context.anim_speed = controller.weapon_stats.get_stat("attack_speed").get_value()
	controller.controller_context.action_time_ratio = controller.action_time_ratio
	controller.controller_context.projectile_template = controller.projectile_template
	controller.controller_context.controller = controller

func finish_execute():
	pass

func _on_projectile_hit(hit : RID):
	projectile_hit.emit(hit)
	pass
