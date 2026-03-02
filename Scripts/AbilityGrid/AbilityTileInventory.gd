class_name AbilityTileInventory extends AbilityGrid



##var grid_coords : Dictionary[Vector2i, AbilityGridSlot]
#var occupied_slots : Dictionary[Vector2i, AbilityGridSlot]
#var ability_tiles : Dictionary[AbilityTile, Vector2i]
#
#var initialized : bool = false

signal graph_changed()

func initialize():
	for coord in initial_ability_tiles:
		var tile : AbilityTile = initial_ability_tiles.get(coord)
		if place_tile_on_slot(initial_ability_tiles[coord], coord):
			print("PLACE " + tile.name + " ON Position: " + str(coord))
		else:
			print("CANNOT PLACE " + tile.name + " ON Position: " + str(coord))
		pass
	pass

func generate_grid():
	for y in range(size.y):
		for x in range(size.x):
			var grid_coord : Vector2i = Vector2i(x, y)
			var slot : AbilityGridSlot = AbilityGridSlot.new()
			slot.grid_pos = grid_coord
			grid_coords[grid_coord] = slot
			pass
		pass
	initialized = true
	pass
