class_name AbilityGridUI extends Control

enum UIState {IDLE, HOLDING, ROLLBACK, PLACE_INVENTORY, PLACE_ABILITY_GRID}

@onready var ability_grid_panel: AbilityGridUIPanel = %AbilityGridPanel
@onready var ability_tile_inventory_panel: AbilityTileInventoryPanelUI = %AbilityTileInventoryPanel
@onready var cursor_ui: CursorUI = %CursorUI
@export var ui_fsm : AbilityGridUIFSM

@onready var debug_state_label: Label = %DebugStateLabel
 

var state : UIState = UIState.IDLE
var pre_state_input : Dictionary[StringName, Variant]
var curr_state_input : Dictionary[StringName, Variant]
var player : PlayerController

signal clicked_void()

func _ready() -> void:
	player = PlayerServer.main_player
	visible = false
	ui_fsm.initialize(self)
	ui_fsm.start({})

func open_ui():
	visible = !visible
	
	if visible:
		cursor_ui.follow_mouse_pos(get_local_mouse_position())  
		ability_grid_panel.generate_grid_ui(player.ability_grid)
		ability_tile_inventory_panel.generate_grid_ui(player.ability_tile_inventory)
		
		connect_ability_grid_slots()
		connect_ability_inventory_slots()
		
		
	else:
		ability_grid_panel.clear_grid_ui()
		ability_tile_inventory_panel.clear_grid_ui()
		cursor_ui.clear()
		update_state(state, {})
	pass

func connect_ability_inventory_slots():
	for slot in ability_tile_inventory_panel.slots:
		ability_tile_inventory_panel.slots[slot].slot_hovered.connect(_on_ability_inventory_slot_hovered)
		ability_tile_inventory_panel.slots[slot].slot_clicked.connect(_on_ability_inventory_slot_clicked)
		ability_tile_inventory_panel.slots[slot].slot_exited.connect(_on_ability_inventory_slot_exited)
	pass

func connect_ability_grid_slots():
	for slot in ability_grid_panel.slots:
		ability_grid_panel.slots[slot].slot_hovered.connect(_on_ability_grid_slot_hovered)
		ability_grid_panel.slots[slot].slot_clicked.connect(_on_ability_grid_slot_clicked)
		ability_grid_panel.slots[slot].slot_exited.connect(_on_ability_grid_slot_exited)
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_TAB and event.pressed:
			print("OPEN ABILITY GRAPH UI")
			open_ui()
			pass

func preview_tile():
	
	pass

func attemp_to_add_tile():
	
	pass

func _gui_input(event: InputEvent) -> void:
	cursor_ui.follow_mouse_pos(get_local_mouse_position())
	
	debug_state_label.text = str(ui_fsm.get_current_state())
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			clicked_void.emit()
			pass
		pass
	pass


func update_state(current_state : UIState, input : Dictionary[StringName, Variant]):
	pass

func _on_ability_grid_slot_hovered(coord : Vector2i):
	#print("HOVERED SLOT COORD:" + str(coord))
	pass

func _on_ability_grid_slot_clicked(coord : Vector2i):
	var input : Dictionary[StringName, Variant] = {}
	input["slot_coord"] = coord
	input["ability_tile"] = player.ability_grid.get_tile_on_slot(coord)
	input["tile_rect"] = ability_grid_panel.get_tile_rect(input["ability_tile"])
	input["ability_grid"] = player.ability_grid
	#print("STATE INPUT: " + str(input))
	ui_fsm.send_input(input)
	pass


func _on_ability_grid_slot_exited(coord : Vector2i):
	#print("EXITED SLOT COORD:" + str(coord))
	pass

func _on_ability_inventory_slot_hovered(coord : Vector2i):
	#print("HOVERED SLOT COORD:" + str(coord))
	pass

func _on_ability_inventory_slot_clicked(coord : Vector2i):
	var input : Dictionary[StringName, Variant] = {}
	input["slot_coord"] = coord
	input["ability_tile"] = player.ability_tile_inventory.get_tile_on_slot(coord)
	input["tile_rect"] = ability_tile_inventory_panel.get_tile_rect(input["ability_tile"])
	input["inventory_grid"] = player.ability_tile_inventory
	#print("STATE INPUT: " + str(input))
	ui_fsm.send_input(input)
	pass

func _on_ability_inventory_slot_exited(coord : Vector2i):
	#print("EXITED SLOT COORD:" + str(coord))
	pass

func _on_slot_exited(coord : Vector2i):
	#print("EXITED SLOT COORD:" + str(coord))
	pass
