class_name EntityNode extends Node

@export var stats_node : StatsNode
@export var action_point : Node2D
@export var equipment_manager : EquipmentManager
var entity : Entity

var initialized : bool = false

func initialize(rid : RID):
	if entity == null:
		entity = Entity.new()
		entity.equipment_manager = equipment_manager
		entity.stats = stats_node.build_stats()
		entity.initalize(rid)
		initialized = true
	pass

func _process(delta: float) -> void:
	if !initialized:
		return
	entity.action_point = action_point.global_position

func _exit_tree() -> void:
	if entity != null:
		print("ENTITY FROM ENTITY NODE FREED")
		EntityServer.to_free(entity.entity_rid)
		entity = null
	pass
