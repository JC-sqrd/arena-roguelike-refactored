@abstract
class_name Item extends Resource

@export var item_name : String
@export var item_id : StringName

@abstract
func equip(context : EquipContext)

@abstract
func unequip()
