class_name AbilityGridUIPanel extends Control


@onready var grid_container: GridContainer = %GridContainer
@onready var texture_layer: Control = %TextureLayer

var tile_rects : Dictionary[AbilityTile, AbilityTileTextureRect]

const _SLOT = preload("uid://dirhqxxxcbmm1")
const _TILE_RECT = preload("uid://ckttdtqqs6nu2")

var slots : Dictionary[Vector2i, AbilityGridSlotUI]

func generate_grid_ui(ability_grid : AbilityGrid):
	clear_grid_ui()
	grid_container.columns = ability_grid.size.x
	for coord in ability_grid.grid_coords:
		var slot : AbilityGridSlotUI = _SLOT.instantiate() as AbilityGridSlotUI
		slot.grid_coord = coord
		slots[coord] = slot
		grid_container.add_child(slot)
		pass
		
	for tile in ability_grid.ability_tiles:
		var grid_pos : Vector2i = ability_grid.ability_tiles.get(tile)
		add_tile_rect(tile, grid_pos)
	pass

func get_tile_rect(tile : AbilityTile) -> AbilityTileTextureRect:
	var tile_rect : AbilityTileTextureRect = tile_rects.get(tile)
	if tile_rect != null:
		return tile_rect
	return null

func pop_tile_rect(tile : AbilityTile) -> AbilityTileTextureRect:
	var tile_rect : AbilityTileTextureRect = get_tile_rect(tile)
	if tile_rect != null:
		tile_rects.erase(tile)
		texture_layer.remove_child(tile_rect)
		return tile_rect
	return null

func add_tile_rect(tile : AbilityTile, grid_pos : Vector2i):
	var tile_rect : AbilityTileTextureRect = _TILE_RECT.instantiate() as AbilityTileTextureRect
	tile_rects[tile] = tile_rect
	tile_rect.initialize(tile, grid_pos)
	texture_layer.add_child(tile_rect)
	pass

func remove_tile_rect(tile : AbilityTile):
	var tile_rect : AbilityTileTextureRect = tile_rects.get(tile)
	if tile_rect != null:
		tile_rects.erase(tile)
		tile_rect.queue_free()
		pass
	pass
func clear_grid_ui():
	for child in grid_container.get_children():
		child.queue_free()
	
	slots.clear()
	
	for child in texture_layer.get_children():
		child.queue_free()
	pass
