class_name GrantStatUpgradeLeaf extends WeaponUpgrade

@export var weapon_stat_id : StringName
@export var stat_value : float = 0


func _on_apply():
	print("UPGRADE INITIALIZED: " + str(weapon_controller))
	weapon_controller.weapon_stats.get_stat(weapon_stat_id).add_bonus_value(stat_value)
	pass

func _on_remove():
	weapon_controller.weapon_stats.get_stat(weapon_stat_id).add_bonus_value(-stat_value)
	pass
