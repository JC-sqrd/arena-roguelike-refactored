class_name BaseAbilityGridUIController extends Control


@onready var cursor_ui: CursorUI = %CursorUI

var player : PlayerController
var _hovered_ui : AbilityGridUI = null
var _held_tile : AbilityTile = null
var _original_grid : AbilityGrid
var _original_pos : Vector2i
var _original_rotation_idx : int = 0


func _process(delta: float) -> void:
	if visible:
		cursor_ui.follow_mouse_pos(get_local_mouse_position())

func setup_grid_signals(grid_ui : AbilityGridUI):
	grid_ui.mouse_entered.connect(_on_grid_mouse_entered.bind(grid_ui))
	grid_ui.slot_clicked.connect(_on_slot_clicked)
	pass

func disconnect_grid_signals(grid_ui : AbilityGridUI):
	grid_ui.mouse_entered.disconnect(_on_grid_mouse_entered.bind(grid_ui))
	grid_ui.slot_clicked.disconnect(_on_slot_clicked)
	pass

func _on_slot_clicked(slot_pos : Vector2i, grid : AbilityGrid):
	if _held_tile == null:
		_pick_up_tile(slot_pos, grid)
		pass
	else:
		_attempt_placement(slot_pos, grid)
	pass

func _pick_up_tile(slot_pos : Vector2i, grid : AbilityGrid):
	var tile : AbilityTile = grid.get_tile_on_slot(slot_pos)
	if tile == null : return
	
	var tile_rect : AbilityTileTextureRect = _hovered_ui.pop_tile_rect(tile)
	tile_rect.position = Vector2.ZERO - tile_rect.get_root_offset_position(tile.offsets)
	cursor_ui.add_child(tile_rect)
	
	var adjacent_tiles : Dictionary[Vector2i, AbilityTile] = grid.get_adjacent_tiles(tile)
	_held_tile = tile
	_original_grid = grid
	_original_pos = grid.ability_tiles.get(tile)
	_original_rotation_idx = tile.rotation_index
	
	grid.remove_tile_on_slot(slot_pos)
	_update_adjacent_tiles(adjacent_tiles, grid)
	tile.update_adjacent_tiles({})
	pass

func _attempt_placement(slot_pos : Vector2i, grid : AbilityGrid):
	if can_place_tile(_held_tile, grid, slot_pos):
		_confirm_placement(slot_pos, grid)
		pass
	else:
		_rollback_placement()
	pass

func can_place_tile(tile : AbilityTile, grid : AbilityGrid, pos : Vector2i) -> bool:
	return grid.can_place(tile, pos)

func _confirm_placement(slot_pos : Vector2i, grid : AbilityGrid):
	if grid.place_tile_on_slot(_held_tile, slot_pos):
		_held_tile.update_adjacent_tiles(grid.get_adjacent_tiles_from_adjacent_points(_held_tile))
		_update_adjacent_tiles(grid.get_adjacent_tiles(_held_tile), grid)
		_clear_helt_state()
		pass
	pass

func _rollback_placement():
	_held_tile.set_rotation_to(_original_rotation_idx)
	_original_grid.place_tile_on_slot(_held_tile, _original_pos)
	_held_tile.update_adjacent_tiles(_original_grid.get_adjacent_tiles_from_adjacent_points(_held_tile))
	_update_adjacent_tiles(_original_grid.get_adjacent_tiles(_held_tile), _original_grid)
	_clear_helt_state()
	pass

func _clear_helt_state():
	_held_tile = null
	_original_grid = null
	_original_pos = Vector2i(-1, -1)
	cursor_ui.clear()
	pass

func _update_adjacent_tiles(tiles : Dictionary[Vector2i, AbilityTile], grid : AbilityGrid):
	for tile_coord in tiles:
		var a_tile : AbilityTile = tiles[tile_coord]
		a_tile.update_adjacent_tiles(grid.get_adjacent_tiles_from_adjacent_points(a_tile))
	pass

func _on_grid_mouse_entered(grid_ui : AbilityGridUI):
	_hovered_ui = grid_ui
	pass
