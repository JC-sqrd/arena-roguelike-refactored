class_name AbilityGridUI extends Control

@onready var ability_grid_panel: AbilityGridUIPanel = %AbilityGridPanel
@onready var ability_tile_inventory_panel: AbilityTileInventoryPanelUI = %AbilityTileInventoryPanel

var player : PlayerController

func _ready() -> void:
	player = PlayerServer.main_player
	visible = false

func open_ui():
	visible = !visible
	
	if visible:
		ability_grid_panel.generate_grid_ui(player.ability_grid)
		ability_tile_inventory_panel.generate_grid_ui(player.ability_tile_inventory)
		
		for slot in ability_grid_panel.slots:
			ability_grid_panel.slots[slot].slot_hovered.connect(_on_slot_hovered)
			ability_grid_panel.slots[slot].slot_clicked.connect(_on_slot_clicked)
			ability_grid_panel.slots[slot].slot_exited.connect(_on_slot_exited)
			pass
		
		for slot in ability_tile_inventory_panel.slots:
			ability_tile_inventory_panel.slots[slot].slot_hovered.connect(_on_slot_hovered)
			ability_tile_inventory_panel.slots[slot].slot_clicked.connect(_on_slot_clicked)
			ability_tile_inventory_panel.slots[slot].slot_exited.connect(_on_slot_exited)
			pass
		
	else:
		ability_grid_panel.clear_grid_ui()
		ability_tile_inventory_panel.clear_grid_ui()
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
	pass

func _on_slot_hovered(coord : Vector2i):
	print("HOVERED SLOT COORD:" + str(coord))
	pass

func _on_slot_clicked(coord : Vector2i):
	print("CLICKED SLOT COORD: " + str(coord))
	
	pass

func _on_slot_exited(coord : Vector2i):
	print("EXITED SLOT COORD:" + str(coord))
	pass
