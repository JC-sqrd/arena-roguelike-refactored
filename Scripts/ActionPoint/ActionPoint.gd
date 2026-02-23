class_name ActionPoint extends Node2D


@export var pivot_node : Node2D

@export var active : bool = true

var mouse_pos : Vector2
var _pivot_distance : float 
var _mouse_dir : Vector2
var _pivot_to_mouse_dir : Vector2
var _clamped_pos : Vector2

func _process(delta: float) -> void:
	if !active:
		return
	
	mouse_pos = get_global_mouse_position()
	_pivot_distance = (pivot_node.global_position - global_position).length()
	_mouse_dir = mouse_pos.normalized()
	_pivot_to_mouse_dir = (mouse_pos - pivot_node.global_position).normalized()
	
	_clamped_pos = (_pivot_to_mouse_dir * _pivot_distance)
	
	global_position = pivot_node.global_position + _clamped_pos 
	
	#look_at(mouse_pos)
