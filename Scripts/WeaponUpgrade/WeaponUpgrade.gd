class_name WeaponUpgrade extends Resource


@export var upgrade_name : String
@export_multiline("Upgrade Detail") var upgrade_details : String
@export_multiline("Upgrade Description") var upgrade_description : String
@export var upgrade_icon : Texture2D

var weapon_controller : WeaponController



func apply_upgrade(controller : WeaponController):
	weapon_controller = controller
	_on_apply()
	pass

func _on_apply():
	pass

func remove_upgrade():
	weapon_controller = null
	_on_remove()
	pass

func _on_remove():
	pass

func update(delta : float):
	pass
