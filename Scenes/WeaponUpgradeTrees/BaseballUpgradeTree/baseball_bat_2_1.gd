extends WeaponUpgradeNode


func apply_upgrade():
	upgrade_tree.weapon_controller.weapon_stats.get_stat("attack_speed").add_bonus_value(1)
	pass

func remove_upgrade():
	upgrade_tree.weapon_controller.weapon_stats.get_stat("attack_speed").add_bonus_value(-11)
	pass
