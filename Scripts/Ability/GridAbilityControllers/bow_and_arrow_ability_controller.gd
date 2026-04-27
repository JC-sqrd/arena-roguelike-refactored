#Bow and Arrow Controller
extends GridAbilityController

@export var projectile_template : ProjectileTemplate
@export var projectile_effect_templates : Array[EffectTemplate]

@export var hit_threshold : int = 5
var hit_counter : int = 0

func _on_initialized():
	EventServer.weapon_attack_started.connect(_on_weapon_attack_started)
	pass

func _on_weapon_attack_started(weapon_controller : WeaponController):
	hit_counter += 1
	
	if hit_counter >= hit_threshold:
		hit_counter = 0
		var projectile : Projectile = projectile_template.build_projectile()
		projectile.projectile_hit.connect(_on_projectile_hit)
		projectile.direction = caster.global_position.direction_to(ArenaServer.active_arena.get_global_mouse_position())
		var angle : float = projectile.direction.angle()
		projectile.angle = angle
		projectile.texture_angle = angle
		SpawnProjectile.spawn_projectile(projectile, caster.action_point + Vector2(randf_range(0,10), randf_range(0,-20)))
	pass

func _on_projectile_hit(hit : RID):
	var context : Dictionary[StringName, Variant] = generate_controller_context()
	for template in projectile_effect_templates:
		EffectServer.receive_effect(hit, template.build_effect(context), context)
	pass

func _on_exit_tree():
	EventServer.weapon_attack_started.disconnect(_on_weapon_attack_started)
	
