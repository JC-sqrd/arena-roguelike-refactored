class_name Entity extends Node


@export var stats : Stats

var effect_listener : EffectListener
var health_manager : HealthManager

var can_move : bool = true
var can_atack : bool = true
var can_cast : bool = true

func initalize(rid : RID):
	stats.initialize()
	
	
	effect_listener = EffectListener.new(stats)
	EffectServer.register_effect_listener(rid, effect_listener)
	
	health_manager = HealthManager.new()
	health_manager.initialize(stats)
	pass
