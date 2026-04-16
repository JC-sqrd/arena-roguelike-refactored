class_name WeaponUpgradeUIPanel extends Control

var weapon_data : Weapon
var player : PlayerController
@onready var left_weapon_upgrade_container: WeaponUpgradeContainer = %LeftWeaponUpgradeContainer
@onready var right_weapon_upgrade_container: WeaponUpgradeContainer = %RightWeaponUpgradeContainer

const WEAPON_UPGRADE_UI = preload("uid://dn03flk65sksd")

var left_weapon : WeaponController
var left_upgrade_tree : WeaponUpgradeTree
var right_weapon : WeaponController
var right_upgrade_tree : WeaponUpgradeTree

func initailize():
	player = PlayerServer.main_player
	
	left_weapon = player.player_entity.equipment_manager.weapon_1_controller
	left_upgrade_tree = left_weapon.upgrade_tree
	
	left_weapon_upgrade_container.attempt_to_buy_upgrade.connect(_on_attempt_to_buy_upgrade)
	right_weapon_upgrade_container.attempt_to_buy_upgrade.connect(_on_attempt_to_buy_upgrade)
	
	for child in left_upgrade_tree.get_children():
		if child is WeaponUpgradeNode:
			if child.upgrade_data == null:
				continue
			var upgrade_ui : WeaponUpgradeUI = WEAPON_UPGRADE_UI.instantiate() as WeaponUpgradeUI
			left_weapon_upgrade_container.add_upgrade_ui(upgrade_ui)
			upgrade_ui.initialize(child)
		pass
	
	right_weapon = player.player_entity.equipment_manager.weapon_2_controller
	right_upgrade_tree = right_weapon.upgrade_tree
	
	for child in right_upgrade_tree.get_children():
		if child is WeaponUpgradeNode:
			if child.upgrade_data == null:
				continue
			var upgrade_ui : WeaponUpgradeUI = WEAPON_UPGRADE_UI.instantiate() as WeaponUpgradeUI
			right_weapon_upgrade_container.add_upgrade_ui(upgrade_ui)
			upgrade_ui.initialize(child)
		pass
	pass

func _on_attempt_to_buy_upgrade(upgrade_ui : WeaponUpgradeUI, container : WeaponUpgradeContainer):
	var upgrade_node : WeaponUpgradeNode = upgrade_ui.upgrade_node
	upgrade_node.apply_upgrade()
	upgrade_node.applied = true
	var next_upgrades : Array[Node] = upgrade_node.get_children()
	if !next_upgrades.is_empty():
		var next_upgrade : WeaponUpgradeNode = upgrade_node.get_child(0)
		if next_upgrade.upgrade_data != null:
			upgrade_ui.initialize(next_upgrade)
		else:
			upgrade_ui.buy_buton.disabled = true
			upgrade_ui.buy_buton.text = "UPGRADE APPLIED"

	else:
		upgrade_ui.buy_buton.disabled = true
		upgrade_ui.buy_buton.text = "MAX UPGRADE"
	pass
