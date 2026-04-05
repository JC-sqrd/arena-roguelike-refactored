class_name AbilityShopItemUI extends TextureRect

@export var ability_tile : AbilityTile

var slot_size : float = 16
var root_offset_pos : Vector2

signal item_hovered(shop_item_ui : AbilityShopItemUI)
signal item_exited(shop_item_ui : AbilityShopItemUI)
signal item_clicked(shop_item_ui : AbilityShopItemUI)

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func initialize(_ability_tile : AbilityTile):
	#self.ability_tile = ability_tile
	texture = self.ability_tile.texture
	
	var max_offset : Vector2i = calculate_max_offset(ability_tile.offsets)
	var min_offset : Vector2i = calculate_min_offset(ability_tile.offsets)
	
	var width : float = ((max_offset.x - min_offset.x) + 1) *  slot_size
	var height : float = ((max_offset.y - min_offset.y) + 1) * slot_size
	
	custom_minimum_size = Vector2(width, height)
	size = Vector2(width, height)
	print("ABILITY SHOP ITEM UI SIZE: ", size)
	root_offset_pos = get_root_offset_position(ability_tile.offsets)
	#position = calculate_pos_relative_to_grid(ability_tile, grid_pos)



func calculate_pos_relative_to_grid(ability_tile : AbilityTile, grid_pos : Vector2i) -> Vector2:
	var max_offset : Vector2i = calculate_max_offset(ability_tile.offsets)
	var min_offset : Vector2i = calculate_min_offset(ability_tile.offsets)
	
	var width : float = ((max_offset.x - min_offset.x) + 1) *  slot_size
	var height : float = ((max_offset.y - min_offset.y) + 1) * slot_size
	
	size = Vector2(width, height)
	
	#var root_offset : Vector2i = -min_offset
	return (grid_pos + min_offset) * slot_size

func calculate_min_offset(offsets : Array[Vector2i]) -> Vector2:
	var min_offset : Vector2i = offsets[0]
	for offset in offsets:
		min_offset = Vector2i(min(offset.x, min_offset.x), min(offset.y, min_offset.y))
		pass
	return min_offset

func calculate_max_offset(offsets : Array[Vector2i]):
	var max_offset : Vector2i = offsets[0]
	for offset in offsets:
		max_offset = Vector2i(max(offset.x, max_offset.x), max(offset.y, max_offset.y))
		pass
	return max_offset

func get_root_offset_position(offsets : Array[Vector2i]) -> Vector2:
	var min_offset : Vector2i = calculate_min_offset(offsets)
	return Vector2(-min_offset) * slot_size + Vector2(slot_size, slot_size) * 0.5

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			item_clicked.emit(self)
			pass

func _on_mouse_entered():
	item_hovered.emit(self)
	pass

func _on_mouse_exited():
	item_exited.emit(self)
	pass
