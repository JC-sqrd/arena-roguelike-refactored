class_name WeaponUpgradeController extends Node


var weapon_controller : WeaponController


func initialize(controller : WeaponController):
	weapon_controller = controller
	_on_initialized()
	pass

func _on_initialized():
	pass
