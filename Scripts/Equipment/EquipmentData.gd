@abstract
class_name Equipment extends Resource

@export var equipment_name : String

@abstract
func equip(context : EquipContext)

@abstract
func unequip()
