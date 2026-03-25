extends WeaponUpgradeNode

@export var damage_multiplier : ValueMultiplier

func apply_upgrade():
	upgrade_tree.weapon_controller.weapon_to_hit.connect(_on_weapon_to_hit)
	pass


func _on_weapon_to_hit(hit : RID, effects : Array[Effect], context : Dictionary[StringName, Variant]):
	for effect in effects:
		if effect.effect_id == "damage_effect":
			if effect.mutator != null:
				effect.mutator.value_provider.multipliers.append(damage_multiplier)
				print("DAMAGE MULTIPLIER APPLIED")
			if effect.modifier != null:
				effect.modifier.value_provider.multipliers.append(damage_multiplier)
			pass
	pass
