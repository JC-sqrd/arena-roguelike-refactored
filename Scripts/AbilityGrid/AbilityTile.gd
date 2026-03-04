class_name AbilityTile extends Resource


@export var offsets : Array[Vector2i] = [Vector2i(0,0)]
@export var name : String
@export var texture : Texture2D
@export var ability_controller_scene : PackedScene
var rotation_index : int = 0 : 
	set(value):
		rotation_index = value % 4

signal rotated(rotated_offsets : Vector2i, rotation_degrees : float)

func rotate_clockwise():
	var rotated_offsets : Array[Vector2i]
	rotation_index += 1
	for offset in offsets:
		var rotated_offset : Vector2i = Vector2i(-offset.y, offset.x)
		rotated_offsets.append(rotated_offset)
		pass
	offsets = rotated_offsets
	
	rotated.emit(offsets, rotation_index * 90)
	pass

func set_rotation_to(target_idx : int):
	target_idx = target_idx % 4
	
	var turns_needed : int = (target_idx - rotation_index + 4) % 4
	
	for i in turns_needed:
		rotate_clockwise()
	pass


func build_ability_controller() -> GridAbilityController:
	var controller : GridAbilityController = ability_controller_scene.instantiate() as GridAbilityController
	return controller
	
