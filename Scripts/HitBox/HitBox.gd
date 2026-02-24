class_name HitBox extends Area2D


var effects : Array[Effect]
var context : Dictionary[StringName, Variant]

func _ready() -> void:
	monitorable = false
	collision_layer = 0
	collision_mask = 0

func initialize():
	
	pass
