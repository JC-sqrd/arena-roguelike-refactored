class_name PlayerEntityNode extends EntityNode


func initialize(rid : RID):
	entity = PlayerEntity.new()
	entity.stats = stats_node.build_stats()
	entity.equipment_manager = equipment_manager
	entity.initalize(rid)
	initialized = true
	pass
