class_name Entity extends Node


@export var stats : Stats

var effect_listener : EffectListener
var health_manager : HealthManager

var can_move : bool = true
var can_atack : bool = true
var can_cast : bool = true

var entity_rid : RID
var entity_node : Node2D

func initalize(rid : RID, node : Node2D):
	entity_rid = rid
	entity_node = node
	stats.initialize()
	
	effect_listener = EffectListener.new(stats)
	EffectServer.register_effect_listener(rid, effect_listener)
	
	health_manager = HealthManager.new()
	health_manager.initialize(stats)
	pass


func _exit_tree() -> void:
	EffectServer.free_rid(entity_rid)
	pass
