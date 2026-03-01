class_name AbilityGridUIPanel extends Control


@onready var grid_container: GridContainer = %GridContainer

const _SLOT = preload("uid://dirhqxxxcbmm1")

var slots : Dictionary[Vector2i, AbilityGridSlotUI]

func generate_grid_ui(ability_grid : AbilityGrid):
	grid_container.columns = ability_grid.size.x
	for coord in ability_grid.grid_coords:
		var slot : AbilityGridSlotUI = _SLOT.instantiate() as AbilityGridSlotUI
		slot.grid_coord = coord
		slots[coord] = slot
		grid_container.add_child(slot)
		pass
	pass

func clear_grid_ui():
	for child in grid_container.get_children():
		child.queue_free()
	slots.clear()
	pass
