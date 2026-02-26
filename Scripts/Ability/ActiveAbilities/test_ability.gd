extends ActiveAbility

@export var projectile_action : SpawnProjectileAbilityAction
@export var projectile_template : ProjectileTemplate
@export var damage_effect : EffectTemplate
@export var hitbox_scene : PackedScene


@export_flags_2d_physics var abiltiy_coll_mask : int = 0

var hitbox : DelayHitbox

func initialize(caster : Entity):
	super(caster)
	projectile_action.initialize(caster, self)
	pass

func start():
	hitbox = hitbox_scene.instantiate() as DelayHitbox
	hitbox.effects = [damage_effect.build_effect(ability_context)]
	hitbox.context = ability_context
	hitbox.global_position = caster.action_point
	hitbox.collision_mask = abiltiy_coll_mask
	hitbox.initialize()
	execute()
	pass

func execute():
	ArenaServer.active_arena.add_child(hitbox)
	hitbox.look_at(hitbox.get_global_mouse_position())
	
	for i in range(0):
		
		#projectile_action.shoot_at_mosue = false
		#projectile_action.look_at_mouse = false
		#var rand_dir : Vector2 = Vector2(randf_range(-1, 1), randf_range(-1, 1))
		#projectile_action.projectile_angle = rand_dir.angle()
		#projectile_action.projectile_direction = rand_dir.normalized()
		#projectile_action.do(caster, self)
		
		#var projectile : Projectile = projectile_template.build_projectile()
		#var mouse_pos : Vector2 = caster.entity_node.get_global_mouse_position() - caster.entity_node.global_position 
		#projectile.effects = [damage_effect.build_effect(ability_context)]
		#projectile.context = ability_context
		#projectile.angle = mouse_pos.angle()
		#projectile.texture_angle = projectile.angle
		#projectile.direction = mouse_pos.normalized()
		#SpawnProjectile.spawn_projectile(projectile, caster.action_point.global_position)
		
		await get_tree().create_timer(0.05).timeout
	end()
	pass
