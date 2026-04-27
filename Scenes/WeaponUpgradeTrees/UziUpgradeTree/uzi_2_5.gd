extends WeaponUpgradeNode


@export var lazer_attack_execute : ProjectileAttackExecute
var _old_attack_execute : ProjectileAttackExecute

func apply_upgrade():
	_old_attack_execute = upgrade_tree.weapon_controller.get_attack_execute()
	upgrade_tree.weapon_controller.set_attack_execute(lazer_attack_execute)
	pass

func remove_upgrade():
	upgrade_tree.weapon_controller.set_attack_execute(_old_attack_execute)
	pass
