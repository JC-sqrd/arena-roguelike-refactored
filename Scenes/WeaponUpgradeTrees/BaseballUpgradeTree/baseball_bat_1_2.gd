extends WeaponUpgradeNode


var _old_weapon_input : WeaponControllerInputStrategy

func apply_upgrade():
	upgrade_tree.weapon_controller.scale = Vector2.ONE * 1.25
	pass

func remove_upgrade():
	upgrade_tree.weapon_controller.scale = Vector2.ONE
	pass
