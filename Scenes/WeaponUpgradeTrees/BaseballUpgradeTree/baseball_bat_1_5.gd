extends WeaponUpgradeNode

@export var smash_projectile : ProjectileTemplate
@export var projecile_effects : Array[EffectTemplate]

func apply_upgrade():
	EventServer.entity_died.connect(_on_entity_died)
	pass

func remove_upgrade():
	EventServer.entity_died.disconnect(_on_entity_died)
	pass

func _on_entity_died(entity : Entity, context : Dictionary[StringName, Variant]):
	
	if !context.has("weapon_id"): return
	
	var weapon_id : StringName = context.get("weapon_id")
	
	if weapon_id == upgrade_tree.weapon_controller.weapon_id:
		var projectile : Projectile = smash_projectile.build_projectile()
		var target : Entity = EntityServer.active_entities[context.target_rid]
		var dir : Vector2 = (target.global_position - upgrade_tree.weapon_controller.wielder.global_position).normalized()
		projectile.direction = dir
		projectile.texture_angle = dir.angle()
		projectile.projectile_hit.connect(_on_projectile_hit)
		SpawnProjectile.spawn_projectile(projectile, entity.global_position)
		print("SPAWN A SMASH PROJECTILE")
		pass
	pass

func _on_projectile_hit(hit : RID):
	var context : Dictionary[StringName, Variant] = upgrade_tree.weapon_controller.generate_controller_context()
	for effect_template in projecile_effects:
		var effect : Effect = effect_template.build_effect(context)
		var effect_arr : Array[Effect] = [effect]
		EventServer.weapon_hit.emit(hit, effect_arr, context)
		EffectServer.receive_effect(hit, effect, context)
		pass
	pass
