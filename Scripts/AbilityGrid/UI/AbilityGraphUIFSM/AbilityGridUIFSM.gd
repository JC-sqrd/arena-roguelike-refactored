class_name AbilityGridUIFSM extends Node

var initial_state : AGUIState
var current_state : AGUIState

var curr_input : Dictionary[StringName, Variant]

var ability_grid_ui : AbilityGridUI
var states : Dictionary[StringName, AGUIState]
var active : bool = false

func initialize(agui : AbilityGridUI):
	ability_grid_ui = agui
	var idle : Idle = Idle.new(agui)
	var holding : Holding = Holding.new(agui)
	var place_inventory : PlaceInventory = PlaceInventory.new(agui)
	var place_inventory_to_grid : PlaceInventoryToGrid = PlaceInventoryToGrid.new(agui)
	var place_ability_grid : PlaceAbilityGrid = PlaceAbilityGrid.new(agui)
	var rollback : Rollback = Rollback.new(agui)
	
	
	idle.add_transition(idle_to_holding_transition, holding)
	holding.add_transition(holding_to_place_inventory_transition, place_inventory)
	place_inventory.add_transition(place_inventory_to_idle, idle)
	place_inventory.add_transition(place_inventory_to_place_inventory_to_grid, place_inventory_to_grid)
	
	add_state(idle)
	add_state(holding)
	add_state(place_inventory)
	add_state(place_inventory_to_grid)
	add_state(place_ability_grid)
	add_state(rollback)
	
	set_initial_state(idle)
	current_state = initial_state
	pass

func start(initial_input : Dictionary[StringName, Variant]):
	active = true
	current_state.enter_state(null, initial_input)
	pass

func stop():
	active = false
	current_state = initial_state
	pass

func _process(delta: float) -> void:
	if !active : return
	
	current_state.process_state()
	
	pass

func update_state():
	
	pass

func set_initial_state(state : AGUIState):
	initial_state = state

func get_current_state() -> AGUIState:
	return current_state

func add_state(state : AGUIState):
	states[str(state)] = state
	pass

func send_input(input : Dictionary[StringName, Variant]):
	for transition in current_state.transitions:
		if transition.call(input):
			current_state.exit_state(input)
			var old_state : AGUIState = current_state
			current_state = current_state.transitions[transition]
			current_state.enter_state(old_state, input)
			pass
		pass
	pass

func idle_to_holding_transition(input : Dictionary[StringName, Variant]) -> bool:
	var ability_tile : AbilityTile = input.get("ability_tile")
	if ability_tile != null:
		print("TRANSITION TO HOLDING")
		return true
	return false

func holding_to_place_inventory_transition(input : Dictionary[StringName, Variant]) -> bool:
	if input.has("inventory_grid"):
		print("TRANSITION TO PLACE INVENTORY")
		return true
	return false

func place_inventory_to_idle(input : Dictionary[StringName, Variant]) -> bool:
	if input.size() == 0:
		return true
	return false

func place_inventory_to_place_inventory_to_grid(input : Dictionary[StringName, Variant]) -> bool:
	if input.has("ability_grid"):
		return true
	return false

class AGUIState:
	
	
	var agui : AbilityGridUI
	var transitions : Dictionary[Callable, AGUIState]
	
	func _init(agui : AbilityGridUI) -> void:
		self.agui = agui
		pass
	
	#func transition(input : Dictionary[StringName, Variant]):
		#for transition in transitions:
			#if transition.call(input):
				#
				#pass
			#pass
		#pass
	
	func add_transition(transition_func : Callable, transition_to : AGUIState):
		transitions[transition_func] = transition_to
		pass
	
	func enter_state(from : AGUIState, input : Dictionary[StringName, Variant]):
		pass
	
	func process_state():
		return
	
	func exit_state(input : Dictionary[StringName, Variant]):
		pass
	
	func _to_string() -> String:
		return "AGUIState"
	pass

class Idle extends AGUIState:
	func _to_string() -> String:
		return "Idle"
	pass

#region Holding
class Holding extends AGUIState:
	
	var held : AbilityTile
	var holding_input : Dictionary[StringName, Variant]
	
	func enter_state(from : AGUIState, input : Dictionary[StringName, Variant]):
		
		holding_input = input
		held = input.get("ability_tile")
		
		var tile_rect : AbilityTileTextureRect = input.get("tile_rect")
		var slot_coord : Vector2i = input.get("slot_coord")
		
		if input.has("inventory_grid"):
			var inventory : AbilityTileInventory = input.get("inventory_grid")
			inventory.remove_tile_on_slot(slot_coord)
			agui.ability_tile_inventory_panel.pop_tile_rect(held)
			agui.cursor_ui.add_child(tile_rect)
			pass
		elif input.has("ability_grid"):
			var ability_grid : AbilityGrid = input.get("ability_grid")
			ability_grid.remove_tile_on_slot(slot_coord)
			agui.ability_grid_panel.pop_tile_rect(held)
			agui.cursor_ui.add_child(tile_rect)
			pass
		pass
	
	func _to_string() -> String:
		return "Holding"
	
	func exit_state(input : Dictionary[StringName, Variant]):
		pass
	
	pass

#endregion Holding

class PlaceInventory extends AGUIState:
	
	func enter_state(from : AGUIState, input : Dictionary[StringName, Variant]):
		if from is Holding:
			if from.holding_input.has("inventory_grid"):
				print("ENTERED PLACE_INVENTORY FROM HOLDING")
				var held : AbilityTile = from.held
				var held_slot : Vector2i = from.holding_input["slot_coord"]
				var slot_coord : Vector2i = input.get("slot_coord")
				var inventory : AbilityTileInventory = input.get("inventory_grid")
				
				if inventory.place_tile_on_slot(held, slot_coord):
					agui.cursor_ui.clear()
					agui.ability_tile_inventory_panel.generate_grid_ui(inventory)
					agui.connect_ability_inventory_slots()
					agui.ui_fsm.send_input({})
				else:
					print(inventory.place_tile_on_slot(held, held_slot))
					agui.cursor_ui.clear()
					agui.ability_tile_inventory_panel.generate_grid_ui(inventory)
					agui.connect_ability_inventory_slots()
					agui.ui_fsm.send_input({})
				pass
			elif from.holding_input.has("ability_grid"):
				agui.ui_fsm.send_input(input)
				pass
		
	func process_state():
		pass
	
	func _to_string() -> String:
		return "PlaceInventory"
	pass

class PlaceInventoryToGrid extends AGUIState:
	
	
	func enter_state(from : AGUIState, input : Dictionary[StringName, Variant]):
		
		pass
	
	
	func _to_string() -> String:
		return "PlaceInventoryToGrid"
	pass

class PlaceAbilityGrid extends AGUIState:
	func _to_string() -> String:
		return "PlaceAbilityGrid"
	pass

class Rollback extends AGUIState:
	func _to_string() -> String:
		return "Rollback"
	pass
