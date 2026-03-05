@tool
class_name FlipOnNodeRotation extends Node

enum FlipType {X, Y, BOTH}

@export var target_node : Node2D
@export var nodes_to_flip : Array[Node2D]
@export var flip_type : FlipType = FlipType.X

@export var min_rotation : float = 0
@export var max_rotation : float = 0


var _is_out_of_bounds : bool = false

var _is_currently_out : bool = false

func _process(delta: float) -> void:
	_is_currently_out = (target_node.rotation_degrees > max_rotation or target_node.rotation_degrees < min_rotation)
	
	if  _is_currently_out and !_is_out_of_bounds:
		_is_out_of_bounds = true
		flip()
	
	if !_is_currently_out and _is_out_of_bounds:
		print("INVERSE FLIP: ")
		_is_out_of_bounds = false
		flip()
	pass


func flip():
	if flip_type == FlipType.X:
		for node in nodes_to_flip:
			node.scale.x = -node.scale.x
	elif flip_type == FlipType.Y:
		for node in nodes_to_flip:
			node.scale.y = -node.scale.y
	else:
		for node in nodes_to_flip:
			node.scale = -node.scale
	pass
