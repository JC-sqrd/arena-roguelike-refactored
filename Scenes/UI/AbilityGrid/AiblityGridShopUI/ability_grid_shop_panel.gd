extends BaseAbilityGridUIController

@onready var ability_inventory_ui: AbilityGridUI = %AbilityInventoryUI
@onready var shop_item_container: HBoxContainer = %ShopItemContainer
const ABILITY_SHOP_ITEM_UI = preload("uid://dodmy7sq8plp1")

var shop_item_pool : AbilityTileShopItemPool

var _held_item_tile : AbilityTile
var _held_item_shop_ui : AbilityShopItemUI
var _held_shop_item_data : ShopItemData

func initialize_shop_ui(item_pool : AbilityTileShopItemPool):
	shop_item_pool = item_pool
	visibility_changed.connect(_on_visibility_changed)
	player = PlayerServer.main_player
	
	ability_inventory_ui.generate_grid_ui(player.ability_tile_inventory)
	
	for child in shop_item_container.get_children():
		if child is AbilityShopItemUI:
			child.initialize(child.item_data.ability_tile)
			child.item_clicked.connect(_on_item_clicked)
		child.queue_free()
		pass
	
	var shop_item_data : Array[AbilityTileShopItemData] = generate_item_data(4)
	
	for item in shop_item_data:
		var item_ui : AbilityShopItemUI = ABILITY_SHOP_ITEM_UI.instantiate()
		item_ui.item_data =  item.duplicate(true)
		shop_item_container.add_child(item_ui)
		item_ui.initialize(item_ui.item_data.ability_tile)
		item_ui.item_clicked.connect(_on_item_clicked)
	pass

func generate_item_data(amount : int) -> Array[AbilityTileShopItemData]:
	var shop_items_data : Array[AbilityTileShopItemData]
	for i in amount:
		var rand_item : AbilityTileShopItemData = shop_item_pool.get_random_item().get_instance_data() 
		shop_items_data.append(rand_item)
		pass
	return shop_items_data

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
		CurrencyServer.add_gold(-_held_shop_item_data.get_cost())
		_confirm_item_placement(slot_pos, grid)
		pass
	else:
		_rollback_placement()
	pass

func _confirm_item_placement(slot_pos : Vector2i, grid : AbilityGrid):
	if grid.place_tile_on_slot(_held_item_tile.duplicate(true), slot_pos):
		_held_item_tile.update_adjacent_tiles(grid.get_adjacent_tiles_from_adjacent_points(_held_item_tile))
		_update_adjacent_tiles(grid.get_adjacent_tiles(_held_item_tile), grid)
		_clear_item_held_state()
		pass
	pass

func _rollback_placement():
	cursor_ui.remove_child(_held_item_shop_ui)
	shop_item_container.add_child(_held_item_shop_ui)
	_held_item_shop_ui.mouse_filter = Control.MOUSE_FILTER_PASS
	#_held_tile.set_rotation_to(_original_rotation_idx)
	#_original_grid.place_tile_on_slot(_held_tile, _original_pos)
	#_held_tile.update_adjacent_tiles(_original_grid.get_adjacent_tiles_from_adjacent_points(_held_tile))
	#_update_adjacent_tiles(_original_grid.get_adjacent_tiles(_held_tile), _original_grid)
	#_clear_held_state()
	_clear_item_held_state()
	pass

func _clear_item_held_state():
	_held_item_tile = null
	_held_shop_item_data = null
	cursor_ui.clear()
	pass

func _on_item_clicked(shop_item_ui : AbilityShopItemUI):
	if !shop_item_ui.item_data.can_buy(CurrencyServer.current_gold):
		return
	
	if _held_item_tile == null:
		_held_item_shop_ui = shop_item_ui
		_held_shop_item_data = shop_item_ui.item_data
		_held_item_tile = shop_item_ui.item_data.ability_tile
		shop_item_ui.mouse_filter = Control.MOUSE_FILTER_IGNORE
		shop_item_container.remove_child(shop_item_ui)
		cursor_ui.add_child(shop_item_ui)
		shop_item_ui.position = Vector2.ZERO - shop_item_ui.get_root_offset_position(shop_item_ui.item_data.ability_tile.offsets)
	pass

func _pick_up_item(shop_item_ui : AbilityShopItemUI):
	
	pass
