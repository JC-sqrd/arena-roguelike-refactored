class_name AbilityGridUI extends GridUI

const slot_size : int = 64

@onready var grid_container: GridContainer = %GridContainer
@onready var texture_layer: Control = %TextureLayer


const _SLOT = preload("uid://dirhqxxxcbmm1")
const _TILE_RECT = preload("uid://ckttdtqqs6nu2")

var slots : Dictionary[Vector2i, AbilityGridSlotUI]
var tile_rects : Dictionary[AbilityTile, AbilityTileTextureRect]

var _hovered_slot : AbilityGridSlotUI = null

var _ability_grid : AbilityGrid

signal slot_clicked(slot_pos : Vector2i, grid : AbilityGrid)

func generate_grid_ui(ability_grid : AbilityGrid):
	clear_grid_ui()
	grid_container.columns = ability_grid.size.x
	print("ABILITY GRID SIZE: " + str(ability_grid.grid_coords))
	for coord in ability_grid.grid_coords:
		var slot : AbilityGridSlotUI = _SLOT.instantiate() as AbilityGridSlotUI
		slot.grid_coord = coord
		slots[coord] = slot
		grid_container.add_child(slot)
		
		
		slot.slot_hovered.connect(_on_mouse_hovered_slot)
		slot.slot_exited.connect(_on_mouse_exited_slot)
		slot.slot_clicked.connect(_on_mouse_clicked_slot)
		
		pass
		
	for tile in ability_grid.ability_tiles:
		var grid_pos : Vector2i = ability_grid.ability_tiles.get(tile)
		add_tile_rect(tile, grid_pos)
	
	_ability_grid = ability_grid
	_ability_grid.placed_tile.connect(_on_grid_placed_tile)
	_ability_grid.removed_tile.connect(_on_grid_removed_tile)
	
	pass

func update_ui():
	
	
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

func get_hovered_slot() -> AbilityGridSlotUI:
	return _hovered_slot

func _on_mouse_hovered_slot(coord : Vector2i):
	_hovered_slot = slots[coord]
	pass

func _on_mouse_exited_slot(coord : Vector2i):
	_hovered_slot = null
	pass

func _on_mouse_clicked_slot(coord : Vector2i):
	slot_clicked.emit(coord, _ability_grid)
	pass

func _on_grid_placed_tile(tile : AbilityTile, pos : Vector2i):
	add_tile_rect(tile, pos)
	pass

func _on_grid_removed_tile(tile : AbilityTile, pos : Vector2i):
	if tile_rects.has(tile):
		var tile_rect : AbilityTileTextureRect = tile_rects.get(tile)
		tile_rect.slot_size = slot_size
		tile_rects.erase(tile)
		tile_rect.queue_free()
	pass
