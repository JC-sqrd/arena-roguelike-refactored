class_name AbilityTileTextureRect extends TextureRect

const tile_size : float = 64
var ability_tile : AbilityTile

func initialize(ability_tile : AbilityTile, grid_pos : Vector2i):
	self.ability_tile = ability_tile
	var max_offset : Vector2i = Vector2i(0,0)
	var min_offset : Vector2i = Vector2i(0,0)
	for offset in ability_tile.offsets:
		max_offset = Vector2i(max(offset.x, max_offset.x), max(offset.y, max_offset.y))
		min_offset = Vector2i(min(offset.x, min_offset.x), min(offset.y, min_offset.y))
		pass
	
	var width : float = ((max_offset.x - min_offset.x) + 1) *  tile_size
	var height : float = ((max_offset.y - min_offset.y) + 1) * tile_size
	
	size = Vector2(width, height)
	
	var root_offset : Vector2i = -min_offset
	
	position = (grid_pos + min_offset) * tile_size
	
	print("POSITION: " + str(position))
	print("MIN OFFSET: " + str(min_offset))
	texture = ability_tile.texture

func set_tile_texture():
	
	pass

func calculate_root_pos():
	
	pass
