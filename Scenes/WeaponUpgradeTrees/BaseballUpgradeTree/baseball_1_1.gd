extends WeaponUpgradeNode


@export var bonus_knockback : float = 300

func apply_upgrade():
	upgrade_tree.weapon_controller.weapon_stats.get_stat("weapon_knockback").add_bonus_value(bonus_knockback)
	pass

func remove_upgrade():
	upgrade_tree.weapon_controller.weapon_stats.get_stat("weapon_knockback").add_bonus_value(-bonus_knockback)
	pass
