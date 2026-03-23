extends WeaponUpgrade


func _on_apply():
	print("UPGRADE INITIALIZED: " + str(weapon_controller))
	weapon_controller.weapon_stats.get_stat("weapon_damage").add_bonus_value(10)
	pass
