extends BaseAbilityGridUIController

@onready var ability_inventory_ui: AbilityGridUI = %AbilityInventoryUI
@onready var shop_item_container: HBoxContainer = %ShopItemContainer

var _held_item_tile : AbilityTile

func initialize():
	visibility_changed.connect(_on_visibility_changed)
	player = PlayerServer.main_player
	
	ability_inventory_ui.generate_grid_ui(player.ability_tile_inventory)
	
	for child in shop_item_container.get_children():
		if child is AbilityShopItemUI:
			child.initialize(null)
			child.item_clicked.connect(_on_item_clicked)
		pass
	pass


func _on_visibility_changed():
	if visible:
		setup_grid_signals(ability_inventory_ui)
		pass
	else:
		cursor_ui.clear()
		disconnect_grid_signals(ability_inventory_ui)
	pass

func pop_item_from_container():
	
	pass

func _on_slot_clicked(slot_pos : Vector2i, grid : AbilityGrid):
	if _held_item_tile != null:
		print("SLOT CLICKED! ", _held_item_tile)
		_attempt_item_purchase(slot_pos, grid)
		return
	
	if _held_tile == null:
		_pick_up_tile(slot_pos, grid)
		pass
	else:
		_attempt_placement(slot_pos, grid)
	pass

func _attempt_item_purchase(slot_pos : Vector2i, grid : AbilityGrid):
	print("ATTEMPT PURCHASE!")
	_attempt_item_placement(slot_pos, grid)
	pass

func _attempt_item_placement(slot_pos : Vector2i, grid : AbilityGrid):
	if can_place_tile(_held_item_tile, grid, slot_pos):
		_confirm_item_placement(slot_pos, grid)
		pass
	else:
		_rollback_placement()
	pass

func _confirm_item_placement(slot_pos : Vector2i, grid : AbilityGrid):
	if grid.place_tile_on_slot(_held_item_tile, slot_pos):
		_held_item_tile.update_adjacent_tiles(grid.get_adjacent_tiles_from_adjacent_points(_held_item_tile))
		_update_adjacent_tiles(grid.get_adjacent_tiles(_held_item_tile), grid)
		_clear_item_held_state()
		pass
	pass

func _clear_item_held_state():
	_held_item_tile = null
	cursor_ui.clear()
	pass

func _on_item_clicked(shop_item_ui : AbilityShopItemUI):
	if _held_item_tile == null:
		_held_item_tile = shop_item_ui.item_data.ability_tile
		shop_item_ui.mouse_filter = Control.MOUSE_FILTER_IGNORE
		shop_item_container.remove_child(shop_item_ui)
		cursor_ui.add_child(shop_item_ui)
		shop_item_ui.position = Vector2.ZERO - shop_item_ui.get_root_offset_position(shop_item_ui.item_data.ability_tile.offsets)
	pass

func _pick_up_item(shop_item_ui : AbilityShopItemUI):
	
	pass
