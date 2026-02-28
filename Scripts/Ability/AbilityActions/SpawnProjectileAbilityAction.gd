class_name SpawnProjectileAbilityAction extends AbilityAction


@export var projectile_template : ProjectileTemplate
##The effects that the projectile will apply to valid targets.
@export var effects_template : Array[EffectTemplate]

##Projectile is spawned looking at the global mouse position.
@export var look_at_mouse : bool = true
##Spawn the projectile at a specific angle, if look_at_mosue is set to true, this field does nothing.
@export var projectile_angle : float = 0
##Spawn the projectile moving towards the global mouse position
@export var shoot_at_mosue : bool = true
##Spawn the projectie moving at a specific direction, if shoot_at_mouse is set to true, this field does nothing.
@export var projectile_direction : Vector2 
var effects : Array[Effect]


func initialize(caster : Entity, ability : Ability):
	for template in effects_template:
		effects.append(template.build_effect(ability.ability_context))

func do(caster : Entity, ability : Ability):
	self.caster = caster
	
	spawn_projectile(caster, ability.ability_context)
	pass

func spawn_projectile(caster : Entity, ability_context : Dictionary[StringName, Variant]):
	var projectile : Projectile = projectile_template.build_projectile()
	var mouse_pos : Vector2 = ProjectileServer.get_global_mouse_position() - caster.global_position
	projectile.effects = effects
	projectile.context = ability_context
	if look_at_mouse:
		projectile.angle = mouse_pos.angle()
		projectile.direction = mouse_pos.normalized()
	else:
		projectile.angle = projectile_angle
	if shoot_at_mosue:
		projectile.direction = mouse_pos.normalized()
	else:
		projectile.direction = projectile_direction
	
	projectile.texture_angle = projectile.angle
	SpawnProjectile.spawn_projectile(projectile, caster.action_point)
	pass
