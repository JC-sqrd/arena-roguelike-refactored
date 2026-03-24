class_name WeaponUpgradeTree extends Node


@export var branches : Array[WeaponUpgradeNode]

var weapon_controller : WeaponController

func initialize(weapon_controller : WeaponController):
	self.weapon_controller = weapon_controller
	pass

func _ready() -> void:
	for child in get_children():
		if child is WeaponUpgradeNode:
			child.initialize(self)
		pass
	pass
