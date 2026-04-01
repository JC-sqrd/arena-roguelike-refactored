extends WeaponUpgradeNode





@export var damage_multiplier : ValueMultiplier
@export var distance_threshold : float = 48

func apply_upgrade():
	upgrade_tree.weapon_controller.weapon_to_hit.connect(_on_weapon_to_hit)
	pass

func remove_upgrade():
	upgrade_tree.weapon_controller.weapon_to_hit.disconnect(_on_weapon_to_hit)
	pass

func _on_weapon_to_hit(hit : RID, effects : Array[Effect], context : Dictionary[StringName, Variant]):
	var dist_sqrd : float = (EntityServer.active_entities[hit].global_position - (context.source.global_position as Vector2)).length_squared()
	var threshold_sqrd : float = distance_threshold ** 2
	
	if (dist_sqrd <= threshold_sqrd):
		return
	
	for effect in effects:
		if effect.effect_id == "damage_effect":
			if effect.mutator != null:
				effect.mutator.value_provider.multipliers.append(damage_multiplier)
			if effect.modifier != null:
				effect.modifier.value_provider.multipliers.append(damage_multiplier)
			pass
	pass
