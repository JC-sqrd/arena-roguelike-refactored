class_name Entity extends RefCounted

var stats : Stats
var action_point : Vector2

var effect_listener : EffectListener
var health_manager : HealthManager
var equipment_manager : EquipmentManager

var can_move : bool = true
var can_attack : bool = true
var can_cast : bool = true

var entity_rid : RID
var entity_node : Node2D

var global_position : Vector2
var velocity : Vector2

signal died(context : Dictionary[StringName, Variant])

func initalize(rid : RID):
	entity_rid = rid
	#entity_node = node
	stats.initialize()
	
	effect_listener = EffectListener.new(self)
	EffectServer.register_effect_listener(rid, effect_listener)
	
	health_manager = HealthManager.new()
	health_manager.initialize(self)
	
	if equipment_manager != null:
		equipment_manager.initialize(self)
	
	pass

func cleanup():
	print("ENTITY CLEANUP")
	print_stack()
	stats.cleanup()
	health_manager.cleanup()
	EffectServer.free_rid(entity_rid)
	effect_listener.cleanup()
	stats = null
	health_manager = null
	effect_listener = null
	stats = null
	entity_rid = RID()
	pass

#func _exit_tree() -> void:
#	EffectServer.free_rid(entity_rid)
#	pass
