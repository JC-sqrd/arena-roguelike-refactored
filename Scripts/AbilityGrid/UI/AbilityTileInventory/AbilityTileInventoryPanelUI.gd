class_name AbilityTileInventoryPanelUI extends Node

@onready var grid_container: GridContainer = %GridContainer
@onready var texture_layer: Control = %TextureLayer

const _SLOT = preload("uid://dirhqxxxcbmm1")
const _TILE_RECT = preload("uid://ckttdtqqs6nu2")

var slots : Dictionary[Vector2i, AbilityGridSlotUI]


func generate_grid_ui(inventory : AbilityTileInventory):
	clear_grid_ui()
	grid_container.columns = inventory.size.x
	for coord in inventory.grid_coords:
		var slot : AbilityGridSlotUI = _SLOT.instantiate() as AbilityGridSlotUI
		slot.grid_coord = coord
		slots[coord] = slot
		grid_container.add_child(slot)
		pass
		
	for tile in inventory.ability_tiles:
		var tile_rect : AbilityTileTextureRect = _TILE_RECT.instantiate() as AbilityTileTextureRect
		var grid_pos : Vector2i = inventory.ability_tiles.get(tile)
		tile_rect.initialize(tile, grid_pos)
		texture_layer.add_child(tile_rect)
		pass
	pass



func clear_grid_ui():
	for child in grid_container.get_children():
		child.queue_free()
	
	slots.clear()
	
	for child in texture_layer.get_children():
		child.queue_free()
	pass
