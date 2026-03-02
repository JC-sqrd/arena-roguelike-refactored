class_name GridUI extends Control

signal hovered(grid_ui : GridUI)
signal exited(grid_ui : GridUI)

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	pass

func generate_grid_ui(ability_grid : AbilityGrid):
	pass

func get_tile_rect(tile : AbilityTile) -> AbilityTileTextureRect:
	return null

func pop_tile_rect(tile : AbilityTile) -> AbilityTileTextureRect:
	return null

func add_tile_rect(tile : AbilityTile, grid_pos : Vector2i):
	pass

func remove_tile_rect(tile : AbilityTile):
	pass

func clear_grid_ui():
	pass


func _on_mouse_entered():
	hovered.emit(self)
	pass

func _on_mouse_exited():
	exited.emit(self)
	pass
