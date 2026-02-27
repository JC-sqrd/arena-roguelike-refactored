@abstract
class_name Equipment extends Resource

@export var equipment_name : String
@export var equipment_id : StringName

@abstract
func equip(context : EquipContext)

@abstract
func unequip()
