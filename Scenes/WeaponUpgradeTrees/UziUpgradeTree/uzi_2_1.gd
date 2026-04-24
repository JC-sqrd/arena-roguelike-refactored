extends WeaponUpgradeNode

@export var bonus_pierce : int = 1

func apply_upgrade():
	(upgrade_tree.weapon_controller as ProjectileWeaponController).projectile_template.pierce += bonus_pierce
	pass

func remove_upgrade():
	(upgrade_tree.weapon_controller as ProjectileWeaponController).projectile_template.pierce -= bonus_pierce
	pass
