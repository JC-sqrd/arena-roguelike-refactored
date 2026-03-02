class_name AbilityGridUIController extends Control

@export var ability_grid_ui : AbilityGridUI
@export var ability_inventory_ui : AbilityGridUI

@onready var cursor_ui: CursorUI = %CursorUI

@onready var debug_state_label: Label = %DebugStateLabel
 
var player : PlayerController

var _hovered_ui : AbilityGridUI = null
var _held_tile : AbilityTile = null
var _source_grid : AbilityGrid = null
var _original_grid : AbilityGrid
var _original_pos : Vector2i

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
			print("OPEN ABILITY GRID UI")
			open_ui()
			pass

func _gui_input(event: InputEvent) -> void:
	if visible:
		cursor_ui.follow_mouse_pos(get_local_mouse_position())
	pass

func _on_ability_grid_ui_slot_clicked(slot_pos : Vector2i, ability_grid : AbilityGrid):
	print(str(ability_inventory_ui._ability_grid.get_instance_id()) +" | "+ str(ability_grid.get_instance_id()))
	if _held_tile == null:
		var tile : AbilityTile = ability_grid.get_tile_on_slot(slot_pos)
		if tile != null:
			var tile_rect : AbilityTileTextureRect = _hovered_ui.pop_tile_rect(tile)
			cursor_ui.add_child(tile_rect)
			ability_grid.remove_tile_on_slot(slot_pos)
			_held_tile = tile
			_original_grid = ability_grid
			_original_pos = slot_pos
			return
		pass
		
	if _held_tile != null:
		if ability_grid.place_tile_on_slot(_held_tile, slot_pos):
			_held_tile = null
			_original_grid = null
			_original_pos = Vector2i(-1,-1)
			cursor_ui.clear()
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
