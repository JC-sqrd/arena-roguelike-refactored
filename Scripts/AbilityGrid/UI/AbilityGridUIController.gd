class_name AbilityGridUIController extends BaseAbilityGridUIController

@export var ability_grid_ui : AbilityGridUI
@export var ability_inventory_ui : AbilityGridUI

func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	player = PlayerServer.main_player
	
	player.initialized_grids.connect(
		func(ability_grid : AbilityGrid, ability_inventory : AbilityGrid):
			ability_grid_ui.generate_grid_ui(ability_grid)
			ability_inventory_ui.generate_grid_ui(ability_inventory)
	)
	pass

func _on_visibility_changed():
	if visible:
		setup_grid_signals(ability_grid_ui)
		setup_grid_signals(ability_inventory_ui)
		pass
	else:
		cursor_ui.clear()
		disconnect_grid_signals(ability_grid_ui)
		disconnect_grid_signals(ability_inventory_ui)
	pass


func _unhandled_input(event: InputEvent) -> void:
	#if event is InputEventKey and event.keycode == KEY_TAB and event.pressed:
		#open_ui()
		#pass
	
	if event is InputEventKey and event.keycode == KEY_I and event.pressed:
		ability_grid_ui.show_locked_slots()
		ability_grid_ui.get_parent().update_minimum_size()
		pass
	
