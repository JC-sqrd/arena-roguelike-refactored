class_name WeaponUpgradeBranchUI extends Control


var upgrade_branch : WeaponUpgradeNode

func initialize(upgrade_branch : WeaponUpgradeNode):
	for leaf in upgrade_branch:
		var upgrade_leaf_ui : WeaponUpgradeIcon = WeaponUpgradeIcon.new()
		pass
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
