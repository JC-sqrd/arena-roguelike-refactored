class_name AbilityTileTextureRect extends TextureRect

var slot_size : float = 16
var ability_tile : AbilityTile
var root_offset_pos : Vector2

func initialize(ability_tile : AbilityTile, grid_pos : Vector2i):
	self.ability_tile = ability_tile
	texture = ability_tile.texture
	
	var max_offset : Vector2i = calculate_max_offset(ability_tile.offsets)
	var min_offset : Vector2i = calculate_min_offset(ability_tile.offsets)
	
	var width : float = ((max_offset.x - min_offset.x) + 1) *  slot_size
	var height : float = ((max_offset.y - min_offset.y) + 1) * slot_size
	
	size = Vector2(width, height)
	root_offset_pos = get_root_offset_position(ability_tile.offsets)
	pivot_offset = root_offset_pos
	rotation_degrees = ability_tile.rotation_index * 90
	position = calculate_pos_relative_to_grid(ability_tile, grid_pos)
	

func calculate_pos_relative_to_grid(ability_tile : AbilityTile, grid_pos : Vector2i) -> Vector2:
	var max_offset : Vector2i = calculate_max_offset(ability_tile.offsets)
	var min_offset : Vector2i = calculate_min_offset(ability_tile.offsets)
	
	var width : float = ((max_offset.x - min_offset.x) + 1) *  slot_size
	var height : float = ((max_offset.y - min_offset.y) + 1) * slot_size
	
	size = Vector2(width, height)
	
	#var root_offset : Vector2i = -min_offset
	return (grid_pos + min_offset) * slot_size

func calculate_min_offset(offsets : Array[Vector2i]) -> Vector2:
	var min_offset : Vector2i = offsets[0]
	for offset in offsets:
		min_offset = Vector2i(min(offset.x, min_offset.x), min(offset.y, min_offset.y))
		pass
	return min_offset

func calculate_max_offset(offsets : Array[Vector2i]):
	var max_offset : Vector2i = offsets[0]
	for offset in offsets:
		max_offset = Vector2i(max(offset.x, max_offset.x), max(offset.y, max_offset.y))
		pass
	return max_offset

func get_root_offset_position(offsets : Array[Vector2i]) -> Vector2:
	var min_offset : Vector2i = calculate_min_offset(offsets)
	return Vector2(-min_offset) * slot_size + Vector2(slot_size, slot_size) * 0.5

#func _draw():
	#draw_circle(root_offset_pos, 5, Color.RED)
