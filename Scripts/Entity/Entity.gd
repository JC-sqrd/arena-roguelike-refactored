class_name Entity extends RefCounted

var stats : Stats
var action_point : Vector2

var effect_listener : EffectListener
var health_manager : HealthManager

var can_move : bool = true
var can_atack : bool = true
var can_cast : bool = true

var entity_rid : RID
var entity_node : Node2D

var global_position : Vector2

func initalize(rid : RID):
	entity_rid = rid
	#entity_node = node
	stats.initialize()
	
	effect_listener = EffectListener.new(stats)
	EffectServer.register_effect_listener(rid, effect_listener)
	
	health_manager = HealthManager.new()
	health_manager.initialize(stats)
	pass


func _exit_tree() -> void:
	EffectServer.free_rid(entity_rid)
	pass
