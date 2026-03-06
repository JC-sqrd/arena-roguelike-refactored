class_name AbilityTile extends Resource


@export var offsets : Array[Vector2i] = [Vector2i(0,0)]
@export var adjacent_points : Array[Vector2i]
@export var name : String
@export var texture : Texture2D
@export var ability_controller_scene : PackedScene

var adjacent_tiles : Dictionary[Vector2i, AbilityTile]

var _active_controller : GridAbilityController

var rotation_index : int = 0 : 
	set(value):
		rotation_index = value % 4

signal rotated(tile : AbilityTile, rotation_degrees : float)

func rotate_clockwise():
	var rotated_offsets : Array[Vector2i]
	var rotated_adjacent_points: Array[Vector2i]
	rotation_index += 1
	for offset in offsets:
		var rotated_offset : Vector2i = Vector2i(-offset.y, offset.x)
		rotated_offsets.append(rotated_offset)
		pass
	
	for point in adjacent_points:
		var rotated_point : Vector2i = Vector2i(-point.y, point.x)
		rotated_adjacent_points.append(rotated_point)
		pass
	
	adjacent_points = rotated_adjacent_points
	offsets = rotated_offsets
	
	rotated.emit(self, rotation_index * 90)
	pass

func set_rotation_to(target_idx : int):
	target_idx = target_idx % 4
	
	var turns_needed : int = (target_idx - rotation_index + 4) % 4
	
	for i in turns_needed:
		rotate_clockwise()
	pass


func get_active_controller() -> GridAbilityController:
	return _active_controller

func build_ability_controller() -> GridAbilityController:
	var controller : GridAbilityController = ability_controller_scene.instantiate() as GridAbilityController
	_active_controller = controller
	return controller
	
