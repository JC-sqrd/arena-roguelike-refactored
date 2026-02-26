class_name PlayerEntity extends Entity


var equipment_manager : EquipmentManager


func initalize(rid : RID):
	super(rid)
	equipment_manager.initialize(self)
	pass
