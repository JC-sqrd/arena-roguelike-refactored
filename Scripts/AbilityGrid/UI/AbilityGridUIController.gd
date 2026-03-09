class_name AbilityGridUIController extends Control

@export var ability_grid_ui : AbilityGridUI
@export var ability_inventory_ui : AbilityGridUI

@onready var cursor_ui: CursorUI = %CursorUI
 
var player : PlayerController

var _hovered_ui : AbilityGridUI = null
var _held_tile : AbilityTile = null
var _source_grid : AbilityGrid = null
var _original_grid : AbilityGrid
var _original_pos : Vector2i
var _original_rotation_idx : int = 0

signal clicked_void()

func _ready() -> void:
	player = PlayerServer.main_player
	
	player.initialized_grids.connect(
		func(ability_grid : AbilityGrid, ability_inventory : AbilityGrid):
			ability_grid_ui.generate_grid_ui(ability_grid)
			ability_inventory_ui.generate_grid_ui(ability_inventory)
			pass
	)
	
	#player.ready.connect(
		#func():
			#ability_grid_ui.generate_grid_ui(player.ability_grid)
	#)
	#player.ready.connect(
		#func():
			#ability_inventory_ui.generate_grid_ui(player.ability_tile_inventory)
			#pass
	#)
	
	visible = false

func open_ui():
	visible = !visible
	
	if visible:
		
		ability_grid_ui.mouse_entered.connect(_on_ability_grid_ui_mouse_entered)
		ability_grid_ui.slot_clicked.connect(_on_ability_grid_ui_slot_clicked)
		
		ability_inventory_ui.mouse_entered.connect(_on_ability_inventory_ui_mouse_entered)
		ability_inventory_ui.slot_clicked.connect(_on_ability_grid_ui_slot_clicked)
	else:
		cursor_ui.clear()
		
		ability_grid_ui.mouse_entered.disconnect(_on_ability_grid_ui_mouse_entered)
		ability_grid_ui.slot_clicked.disconnect(_on_ability_grid_ui_slot_clicked)
		
		ability_inventory_ui.mouse_entered.disconnect(_on_ability_inventory_ui_mouse_entered)
		ability_inventory_ui.slot_clicked.disconnect(_on_ability_grid_ui_slot_clicked)
	pass



func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_TAB and event.pressed:
			if !visible:
				print("OPEN ABILITY GRID UI")
			if visible:
				print("CLOSE ABILITY GRID UI")
				if _held_tile != null:
					pass
			open_ui()
	
	if event is InputEventKey and _held_tile != null:
		if event.keycode == KEY_R and event.pressed:
			#WIP : TILE ROTATION
			#print("ROTATE TILE")
			#cursor_ui.rotate_children_clockwise()
			#_held_tile.rotate_clockwise()
			pass
		pass
	
	if event is InputEventKey:
		if event.keycode == KEY_I and event.pressed:
			ability_grid_ui.show_locked_slots()
			ability_grid_ui.get_parent().update_minimum_size()
			pass 
	pass

func _process(delta: float) -> void:
	if visible:
		cursor_ui.follow_mouse_pos(get_local_mouse_position())

func _gui_input(event: InputEvent) -> void:
	
	pass

func _on_ability_grid_ui_slot_clicked(slot_pos : Vector2i, ability_grid : AbilityGrid):
	#Pickup
	if _held_tile == null:
		var tile : AbilityTile = ability_grid.get_tile_on_slot(slot_pos)
		if tile != null:
			var tile_rect : AbilityTileTextureRect = _hovered_ui.pop_tile_rect(tile)
			tile_rect.position = Vector2.ZERO - tile_rect.get_root_offset_position(tile_rect.ability_tile.offsets)#tile_rect.calculate_pos_relative_to_grid(tile, Vector2i(0,0))
			cursor_ui.add_child(tile_rect)
			tile.update_adjacent_tiles({})
			_held_tile = tile
			_original_grid = ability_grid
			_original_pos = ability_grid.ability_tiles.get(tile)
			_original_rotation_idx = tile.rotation_index
			ability_grid.remove_tile_on_slot(slot_pos)
			return
	#Place
	if _held_tile != null:
		if ability_grid.place_tile_on_slot(_held_tile, slot_pos):
			_held_tile.adjacent_tiles = ability_grid.get_adjacent_tiles_from_adjacent_points(_held_tile)
			var adjacent_tiles : Dictionary[Vector2i, AbilityTile] = ability_grid.get_adjacent_tiles(_held_tile)
			_update_adjacent_tiles(adjacent_tiles, ability_grid)
			print("ADJACENT TILES: " + str(_held_tile.adjacent_tiles))
			_held_tile = null
			_original_grid = null
			_original_pos = Vector2i(-1,-1)
			cursor_ui.clear()
			return
		#Rollback Placement
		else:
			print("ROLLBACK PLACEMENT: " + str(_original_pos))
			print(ability_grid.grid_coords[slot_pos].grid_pos)
			_held_tile.adjacent_tiles = ability_grid.get_adjacent_tiles_from_adjacent_points(_held_tile)
			var adjacent_tiles : Dictionary[Vector2i, AbilityTile] = ability_grid.get_adjacent_tiles(_held_tile)
			_update_adjacent_tiles(adjacent_tiles, ability_grid)
			_held_tile.set_rotation_to(_original_rotation_idx)
			_original_grid.place_tile_on_slot(_held_tile, _original_pos)
			_held_tile = null
			_original_grid = null
			_original_pos = Vector2i(-1,-1)
			cursor_ui.clear()
			return
		pass
	pass


func _update_adjacent_tiles(tiles : Dictionary[Vector2i, AbilityTile], grid : AbilityGrid):
	for tile in tiles:
		var ability_tile : AbilityTile = tiles[tile]
		ability_tile.update_adjacent_tiles(grid.get_adjacent_tiles_from_adjacent_points(ability_tile))
		pass
	pass

func _on_ability_grid_ui_mouse_entered():
	print("HOVERED ABILITY GRID UI")
	_hovered_ui = ability_grid_ui
	pass

func _on_ability_inventory_ui_mouse_entered():
	print("HOVERED ABILITY INVENTORY GRID UI")
	_hovered_ui = ability_inventory_ui
	pass
