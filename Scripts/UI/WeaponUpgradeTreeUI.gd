extends Control


const WEAPON_UPGRADE_BRANCH_UI = preload("uid://di1yn8d0oqxgf")

func initialize(weapon_upgrade_tree : WeaponUpgradeTree):
	for branch in weapon_upgrade_tree.branches:
		#Create a branch ui
		#Iterate through neighbors and do the same thing
		for next_branch in branch.next_nodes:
			
			pass
		pass
	pass


func generate_upgrade_branch_ui(branch : WeaponUpgradeNode) ->  Array[WeaponUpgradeIcon]:
	#WIP -- GENERATE UI BRANCH RECURSIVELY --
	var arr : Array[WeaponUpgradeIcon]
	
	var branch_ui : WeaponUpgradeBranchUI = WEAPON_UPGRADE_BRANCH_UI.instantiate() as WeaponUpgradeBranchUI
	branch_ui.upgrade_branch = branch
	arr.append(branch_ui)
	
	if branch.next_nodes.is_empty():
		return []
	
	for neighbor in  branch.next_nodes:
		var neightbor_branch_ui : WeaponUpgradeBranchUI = WEAPON_UPGRADE_BRANCH_UI.instantiate() as WeaponUpgradeBranchUI
		neightbor_branch_ui.upgrade_branch = neighbor
		arr.append(neightbor_branch_ui)
		pass
	return []
