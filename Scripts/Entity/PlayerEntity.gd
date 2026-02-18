class_name PlayerEntity extends Entity

@export var equipment_manager : EquipmentManager



func initalize(rid : RID):
	super(rid)
	equipment_manager.initialize(stats)
	pass
