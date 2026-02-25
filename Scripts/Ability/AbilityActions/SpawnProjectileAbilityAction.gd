class_name SpawnProjectileAbilityAction extends AbilityAction


@export var projectile_template : ProjectileTemplate
@export var effects_template : Array[EffectTemplate]

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
	var mouse_pos : Vector2 = caster.entity_node.get_global_mouse_position() - caster.entity_node.global_position 
	projectile.effects = effects
	projectile.context = ability_context
	projectile.angle = mouse_pos.angle()
	projectile.texture_angle = projectile.angle
	projectile.direction = mouse_pos.normalized()
	SpawnProjectile.spawn_projectile(projectile, caster.action_point.global_position)
	pass
