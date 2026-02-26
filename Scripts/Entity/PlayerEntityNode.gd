class_name PlayerEntityNode extends EntityNode

@export var equipment_manager : EquipmentManager

func initialize(rid : RID):
	entity = PlayerEntity.new()
	entity.stats = stats_node.build_stats()
	entity.equipment_manager = equipment_manager
	entity.initalize(rid)
	initialized = true
	pass
