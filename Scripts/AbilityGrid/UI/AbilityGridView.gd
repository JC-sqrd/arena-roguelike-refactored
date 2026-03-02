class_name AbilityGridView extends RefCounted

var _ability_grid : AbilityGrid

func _init(ability_grid : AbilityGrid):
	_ability_grid = ability_grid
	pass

func get_size() -> Vector2i:
	return _ability_grid.size

func get_tile_at_slot(slot_pos : Vector2i):
	return _ability_grid.get_tile_on_slot(slot_pos)

func get_controller_grid() -> AbilityGrid:
	return _ability_grid
