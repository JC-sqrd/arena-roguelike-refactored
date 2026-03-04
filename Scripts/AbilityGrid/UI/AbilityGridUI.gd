class_name AbilityGridUI extends GridUI

const slot_size : int = 64

@onready var texture_layer: Control = %TextureLayer
@onready var grid_layer: Control = %GridLayer
@onready var locked_grid: Control = %LockedGrid


const _SLOT = preload("uid://dirhqxxxcbmm1")
const _TILE_RECT = preload("uid://ckttdtqqs6nu2")

var slots : Dictionary[Vector2i, AbilityGridSlotUI]
var tile_rects : Dictionary[AbilityTile, AbilityTileTextureRect]

var _hovered_slot : AbilityGridSlotUI = null

var _ability_grid : AbilityGrid

var _original_size : Vector2
var _original_grid_position : Vector2
var _original_tex_layer_position : Vector2

signal slot_clicked(slot_pos : Vector2i, grid : AbilityGrid)
signal locked_slot_clicked(slot_pos : Vector2i, grid : AbilityGrid)

func generate_grid_ui(ability_grid : AbilityGrid):
	clear_grid_ui()
	print("ABILITY GRID SIZE: " + str(ability_grid.grid_coords))
	
	
	size = ability_grid.get_grid_size() * slot_size
	custom_minimum_size = size
	var ability_grid_bounding_box : Rect2i = ability_grid.get_grid_bounds()
	grid_layer.position = Vector2(-ability_grid_bounding_box.position) * slot_size
	
	_original_size = size
	_original_grid_position = grid_layer.position
	_original_tex_layer_position = texture_layer.position
	
	_generate_grid_ui_contents(ability_grid)
	
	_ability_grid = ability_grid
	_ability_grid.placed_tile.connect(_on_grid_placed_tile)
	_ability_grid.removed_tile.connect(_on_grid_removed_tile)
	
	pass

func _generate_grid_ui_contents(ability_grid : AbilityGrid):
	for coord in ability_grid.grid_coords:
		var slot : AbilityGridSlotUI = _SLOT.instantiate() as AbilityGridSlotUI
		slot.grid_coord = coord
		slots[coord] = slot
		
		
		var slot_pos : Vector2 = coord * slot_size
		slot.position = slot_pos
		grid_layer.add_child(slot)
		
		slot.slot_hovered.connect(_on_mouse_hovered_slot)
		slot.slot_exited.connect(_on_mouse_exited_slot)
		slot.slot_clicked.connect(_on_mouse_clicked_slot)
		pass
		
	for tile in ability_grid.ability_tiles:
		var grid_pos : Vector2i = ability_grid.ability_tiles.get(tile)
		add_tile_rect(tile, grid_pos)
	pass

func show_locked_slots():
	#clear_grid_ui()
	
	if _ability_grid == null:
		printerr("Cannot display locked slots of a null ability grid")
	
	var locked_coords : Array[Vector2i] = _ability_grid.get_locked_coords()
	var grid_coords : Array[Vector2i] = _ability_grid.grid_coords.keys()
	
	grid_coords.append_array(locked_coords)
	
	
	
	
	var size_tweener : Tween = create_tween()
	#size_tweener.tween_property(self, "custom_minimum_size",AbilityGrid.get_grid_size_from_grid_coords(grid_coords) * slot_size, 0.2)
	
	#await  get_tree().process_frame
	
	#var locked_grid_tweener : Tween = create_tween()
	var locked_grid_bounding_box : Rect2i = AbilityGrid.get_grid_bounds_from_grid_coords(grid_coords)
	locked_grid.position = Vector2(-locked_grid_bounding_box.position) * slot_size
	#locked_grid_tweener.tween_property(locked_grid, "position", Vector2(-locked_grid_bounding_box.position) * slot_size, 0.2)
	
	#var grid_layer_tweener : Tween = create_tween()
	var ability_grid_bounding_box : Rect2i = _ability_grid.get_grid_bounds()
	var center_pos : Vector2 = Vector2(-(ability_grid_bounding_box.position + locked_grid_bounding_box.position)) * slot_size
	grid_layer.position = center_pos
	#grid_layer_tweener.tween_property(grid_layer, "position", center_pos, 0.2)
	
	#var tex_layer_tweener : Tween = create_tween()
	texture_layer.position = grid_layer.position
	#tex_layer_tweener.tween_property(texture_layer, "position", center_pos, 0.2)
	
	size = AbilityGrid.get_grid_size_from_grid_coords(grid_coords) * slot_size
	custom_minimum_size = size
	(get_parent() as Control).queue_sort()
	
	
	for coord in locked_coords:
		var slot : AbilityGridSlotUI = _SLOT.instantiate() as AbilityGridSlotUI
		slot.grid_coord = coord
		slots[coord] = slot
		
		
		var slot_pos : Vector2 = coord * slot_size
		slot.position = slot_pos
		locked_grid.add_child(slot)
		
		slot.slot_hovered.connect(_on_mouse_hovered_slot)
		slot.slot_exited.connect(_on_mouse_exited_slot)
		slot.slot_clicked.connect(_on_mouse_clicked_slot)
	
	print("GRID POS: " + str(grid_layer.position))
	
	#_generate_grid_ui_contents(_ability_grid)
	print("SHOWING LOCKED COORDS")
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
	for child in grid_layer.get_children():
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
