class_name EntityNode extends Node

@export var stats_node : StatsNode
@export var action_point : Node2D
var entity : Entity

var initialized : bool = false

func initialize(rid : RID):
	entity = Entity.new()
	entity.stats = stats_node.build_stats()
	entity.initalize(rid)
	initialized = true
	pass

func _process(delta: float) -> void:
	if !initialized:
		return
	entity.action_point = action_point.global_position
