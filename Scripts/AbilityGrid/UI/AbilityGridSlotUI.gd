class_name AbilityGridSlotUI extends Control


var ability_tile : AbilityTile
var grid_coord : Vector2i = Vector2i(0,0)

signal slot_hovered(coord : Vector2i)
signal slot_exited(coord : Vector2i)
signal slot_clicked(coord : Vector2i)

const GRID_ABILITY_TOOLTIP_UI = preload("uid://cbnnyh3j370hp")

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			slot_clicked.emit(grid_coord)
			pass

func _on_mouse_entered():
	slot_hovered.emit(grid_coord)
	pass

func _on_mouse_exited():
	slot_exited.emit(grid_coord)
	pass

func _get_tooltip(at_position: Vector2) -> String:
	if ability_tile != null:
		return ability_tile.name
	return ""

func _make_custom_tooltip(for_text: String) -> Object:
	var tooltip : GridAbilityTooltipUI = GRID_ABILITY_TOOLTIP_UI.instantiate() as GridAbilityTooltipUI
	tooltip.ability_tile = ability_tile
	return tooltip
