class_name ActionPoint extends Node2D


@export var pivot_node : Node2D

var active : bool = false


func _ready() -> void:
	active = true


func _process(delta: float) -> void:
	if !active:
		return
		
	var mouse_pos : Vector2 = get_global_mouse_position()
	var pivot_distance : float = (pivot_node.global_position - global_position).length()
	var mouse_dir : Vector2 = mouse_pos.normalized()
	var pivot_to_mouse_dir : Vector2 = (mouse_pos - pivot_node.global_position).normalized()
	
	var clamped_pos : Vector2 = (pivot_to_mouse_dir * pivot_distance)
	
	global_position = pivot_node.global_position + clamped_pos 
	
	look_at(mouse_pos)
