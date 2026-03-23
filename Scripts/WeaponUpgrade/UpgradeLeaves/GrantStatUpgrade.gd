class_name GrantStatUpgrade extends WeaponUpgrade

@export var weapon_stat_id : StringName
@export var stat_value : float = 0


func _on_apply():
	weapon_controller.weapon_stats.get_stat(weapon_stat_id).add_bonus_value(stat_value)
	pass

func _on_remove():
	weapon_controller.weapon_stats.get_stat(weapon_stat_id).add_bonus_value(-stat_value)
	pass
