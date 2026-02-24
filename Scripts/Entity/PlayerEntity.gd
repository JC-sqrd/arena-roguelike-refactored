class_name PlayerEntity extends Entity

@export var equipment_manager : EquipmentManager



func initalize(rid : RID, node : Node2D):
	super(rid, node)
	equipment_manager.initialize(stats)
	pass
