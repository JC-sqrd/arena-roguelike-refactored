class_name EquipSlot extends Resource

@export var equipped_equipment : Item


func equip(equipment : Item, context : EquipContext):
	equipped_equipment = equipment
	print("EQUIPPED: " + equipment.item_name)
	equipment.equip(context)
	pass


func unequip() -> Item:
	var temp : Item = equipped_equipment
	equipped_equipment = null
	return temp
