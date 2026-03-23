class_name SpawnProjectileOnHitUpgrade extends WeaponUpgrade

@export var projectile_template : ProjectileTemplate
@export var effect_template : EffectTemplate

var effect : Effect
var projectile_context : Dictionary[StringName, Variant]

func _on_apply():
	weapon_controller.weapon_hit.connect(_on_weapon_hit)
	pass

func _on_remove():
	
	pass

func _on_weapon_hit(hits : Array[RID], context : Dictionary[StringName, Variant]):
	projectile_context = context
	var projectile : Projectile = projectile_template.build_projectile()
	projectile.projectile_hit.connect(_on_projectile_hit)
	projectile.direction = (weapon_controller.get_global_mouse_position() - weapon_controller.global_position).normalized()
	projectile.angle = projectile.direction.angle()
	projectile.texture_angle = projectile.direction.angle()
	
	SpawnProjectile.spawn_projectile(projectile, weapon_controller.action_point.global_position)
	pass

func _on_projectile_hit(hit : RID):
	var effect : Effect = effect_template.build_effect(projectile_context)
	EffectServer.receive_effect(hit, effect, projectile_context)
	pass
