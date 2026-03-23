class_name WeaponUpgradeBranchUI extends Control


var upgrade_branch : WeaponUpgradeBranch

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func initialize(upgrade_branch : WeaponUpgradeBranch):
	for leaf in upgrade_branch:
		var upgrade_leaf_ui : WeaponUpgradeIcon = WeaponUpgradeIcon.new()
		pass
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
