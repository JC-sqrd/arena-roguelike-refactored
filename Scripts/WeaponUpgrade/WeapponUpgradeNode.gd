class_name WeaponUpgradeNode extends Node

var upgrade_tree : WeaponUpgradeTree
@export var applied : bool = false
@export var upgrade_data : WeaponUpgradeData


@export var next_nodes : Array[WeaponUpgradeNode]

func initialize(tree : WeaponUpgradeTree):
	upgrade_tree = tree
	for child in get_children():
		if child is WeaponUpgradeNode:
			child.initialize(tree)
			pass
		pass
	if applied:
		apply_upgrade()
	pass

func apply_upgrade():
	
	pass

func remove_upgrade():
	pass
