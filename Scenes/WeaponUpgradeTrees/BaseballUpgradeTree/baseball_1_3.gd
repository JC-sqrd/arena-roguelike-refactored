extends WeaponUpgradeNode


var _old_weapon_input : WeaponControllerInputStrategy

func apply_upgrade():
	_old_weapon_input = upgrade_tree.weapon_controller.weapon_input
	upgrade_tree.weapon_controller.weapon_input = ChargeWeaponInput.new()
	pass

func remove_upgrade():
	upgrade_tree.weapon_controller.weapon_input = _old_weapon_input
	pass
