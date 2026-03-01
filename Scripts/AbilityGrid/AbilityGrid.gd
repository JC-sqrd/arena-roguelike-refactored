class_name AbilityGrid extends Resource


@export var size : Vector2i = Vector2i(5,5)


var grid_coords : Dictionary[Vector2i, AbilityGridSlot]

var initialized : bool = false

signal grid_changed()

func generate_grid():
	for x in range(size.x):
		for y in range(size.y):
			var grid_coord : Vector2i = Vector2i(x, y)
			grid_coords[grid_coord] = AbilityGridSlot.new()
			pass
		pass
	initialized = true
	pass


func place_tile_on_slot():
	if !initialized: return
	
	pass
