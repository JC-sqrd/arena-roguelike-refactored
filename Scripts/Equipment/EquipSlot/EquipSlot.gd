class_name EquipSlot extends Resource

@export var equipped_equipment : Equipment


func equip(equipment : Equipment, context : EquipContext):
	equipped_equipment = equipment
	print("EQUIPPED: " + equipment.equipment_name)
	equipment.equip(context)
	pass


func unequip() -> Equipment:
	var temp : Equipment = equipped_equipment
	equipped_equipment = null
	return temp
