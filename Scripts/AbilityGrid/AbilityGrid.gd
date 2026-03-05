class_name AbilityGrid extends Grid

@export var initial_ability_tiles : Dictionary[Vector2i, AbilityTile]

var grid_coords : Dictionary[Vector2i, AbilityGridSlot]
var occupied_slots : Dictionary[Vector2i, AbilityGridSlot]
var ability_tiles : Dictionary[AbilityTile, Vector2i]

var initialized : bool = false

signal grid_changed()
signal grid_generated()
signal placed_tile(tile : AbilityTile, coord : Vector2i)
signal removed_tile(tile : AbilityTile, coord : Vector2i)


func initialize():
	for coord in initial_ability_tiles:
		var temp_tile : AbilityTile = initial_ability_tiles.get(coord)
		var tile : AbilityTile = temp_tile.duplicate(true)
		if place_tile_on_slot(tile, coord):
			print("PLACE " + tile.name + " ON Position: " + str(coord))
		else:
			print("CANNOT PLACE " + tile.name + " ON Position: " + str(coord))
		pass
	pass

static func get_grid_size_from_grid_coords(coords : Array[Vector2i]):
	var min_coord : Vector2i = coords[0]
	var max_coord : Vector2i = coords[0]
	
	for coord in coords:
		min_coord = Vector2i(min(min_coord.x, coord.x), min(min_coord.y, coord.y))
		max_coord = Vector2i(max(max_coord.x, coord.x), max(max_coord.y, coord.y))
		pass
	
	var width : float = ((max_coord.x - min_coord.x) + 1)
	var height : float = ((max_coord.y - min_coord.y) + 1)
	
	return Vector2(width, height)

static func get_grid_bounds_from_grid_coords(coords : Array[Vector2i]) -> Rect2:
	var min_coord : Vector2i = coords[0]
	var max_coord : Vector2i = coords[0]
	
	for coord in coords:
		min_coord = Vector2i(min(min_coord.x, coord.x), min(min_coord.y, coord.y))
		max_coord = Vector2i(max(max_coord.x, coord.x), max(max_coord.y, coord.y))
		pass
	
	var width : float = ((max_coord.x - min_coord.x) + 1)
	var height : float = ((max_coord.y - min_coord.y) + 1)
	
	return Rect2i(min_coord.x, min_coord.y, width, height)

func add_coord(coord : Vector2i) -> bool:
	if !grid_coords.has(coord):
		grid_coords[coord] = AbilityGridSlot.new()
		grid_changed.emit()
		return true
	return false

func get_locked_coords() -> Array[Vector2i]:
	var directions : Array[Vector2i] = [Vector2i(1,0), Vector2i(-1,0), Vector2i(0,1), Vector2i(0,-1)]
	var locked_slots : Array[Vector2i]
	
	for coord in grid_coords:
		for direction in directions:
			var neighbor : Vector2i = coord + direction
			if !grid_coords.has(neighbor):
				locked_slots.append(neighbor)
				pass
			pass
		pass
	
	return locked_slots

func get_grid_size() -> Vector2:
	var min_coord : Vector2i = grid_coords.keys()[0]
	var max_coord : Vector2i = grid_coords.keys()[0]
	for coord in grid_coords:
		min_coord = Vector2i(min(min_coord.x, coord.x), min(min_coord.y, coord.y))
		max_coord = Vector2i(max(max_coord.x, coord.x), max(max_coord.y, coord.y))
		pass
	
	var width : float = ((max_coord.x - min_coord.x) + 1)
	var height : float = ((max_coord.y - min_coord.y) + 1)
	
	return Vector2(width, height)

func get_grid_bounds() -> Rect2:
	var min_coord : Vector2i = grid_coords.keys()[0]
	var max_coord : Vector2i = grid_coords.keys()[0]
	for coord in grid_coords:
		min_coord = Vector2i(min(min_coord.x, coord.x), min(min_coord.y, coord.y))
		max_coord = Vector2i(max(max_coord.x, coord.x), max(max_coord.y, coord.y))
		pass
	
	var width : float = ((max_coord.x - min_coord.x) + 1)
	var height : float = ((max_coord.y - min_coord.y) + 1)
	
	return Rect2i(min_coord.x, min_coord.y, width, height)


func generate_grid():
	for y in range(size.y):
		for x in range(size.x):
			var grid_coord : Vector2i = Vector2i(x, y)
			grid_coords[grid_coord] = AbilityGridSlot.new()
			pass
		pass
	grid_generated.emit()
	initialized = true
	pass


func get_tile_on_slot(slot_pos : Vector2i) -> AbilityTile:
	var slot : AbilityGridSlot = grid_coords.get(slot_pos)
	if !slot:
		return null 
	return slot.occupied_by

func can_place(ability_tile : AbilityTile, pos : Vector2i) -> bool:
	
	if !grid_coords.has(pos):
		return false
	
	for offset in ability_tile.offsets:
		var slot_offsset : Vector2i = pos + offset
		if slot_offsset.x < 0 or slot_offsset.y < 0:
			return false
		elif slot_offsset.x >= size.x or slot_offsset.y >= size.y:
			return false
		elif grid_coords[slot_offsset].occupied:
			return false
		pass
	return true

func place_tile_on_slot(ability_tile : AbilityTile, grid_pos : Vector2i) -> bool:
	if !grid_coords.has(grid_pos):
		return false
	
	var slots_to_occupy : Array[Vector2i]
	
	for offset in ability_tile.offsets:
		var slot_offsset : Vector2i = grid_pos + offset
		if slot_offsset.x < 0 or slot_offsset.y < 0:
			return false
		elif slot_offsset.x >= size.x or slot_offsset.y >= size.y:
			return false
		elif grid_coords[slot_offsset].occupied:
			return false
		else:
			slots_to_occupy.append(slot_offsset)
		pass
		
	for slot_coord in slots_to_occupy:
		var slot : AbilityGridSlot = grid_coords.get(slot_coord)
		occupied_slots[slot_coord] = grid_coords[slot_coord]
		slot.occupied = true
		slot.occupied_by = ability_tile
		pass
	
	ability_tiles[ability_tile] = grid_pos
	placed_tile.emit(ability_tile, grid_pos)
	return true

func remove_tile_on_slot(grid_pos : Vector2i) -> AbilityTile:
	if !grid_coords.has(grid_pos):
		return null
	
	var ability_tile : AbilityTile = grid_coords[grid_pos].occupied_by
	
	if !ability_tile:
		return null
	
	var tile_pos : Vector2i = ability_tiles.get(ability_tile)
	
	for offset in ability_tile.offsets:
		var slot_offsset : Vector2i = tile_pos + offset
		var slot : AbilityGridSlot = grid_coords.get(slot_offsset)
		occupied_slots.erase(slot_offsset)
		slot.occupied = false
		slot.occupied_by = null
		pass
	
	ability_tiles.erase(ability_tile)
	removed_tile.emit(ability_tile, grid_pos)
	return ability_tile

func pop_tile_on_slot(slot_pos : Vector2i) -> AbilityTile:
	if !grid_coords.has(slot_pos):
		return null
	
	var ability_tile : AbilityTile = grid_coords[slot_pos].occupied_by
	
	if !ability_tile:
		return null
	
	var tile_pos : Vector2i = ability_tiles.get(ability_tile)
	
	for offset in ability_tile.offsets:
		var slot_offsset : Vector2i = tile_pos + offset
		var slot : AbilityGridSlot = grid_coords.get(slot_offsset)
		occupied_slots.erase(slot_offsset)
		slot.occupied = false
		slot.occupied_by = null
		pass
	
	ability_tiles.erase(ability_tile)
	
	removed_tile.emit(ability_tile, tile_pos)
	return ability_tile


func get_adjacent_tiles(tile : AbilityTile) -> Dictionary[Vector2i, AbilityTile]:
	if !ability_tiles.has(tile):
		return {}
	
	var adjacent_tiles : Dictionary[Vector2i, AbilityTile] = {}
	
	var tile_pos : Vector2i = ability_tiles.get(tile)
	
	var directions : Array[Vector2i] = [Vector2i(1,0), Vector2i(-1,0), Vector2i(0,1), Vector2i(0,-1)]
	
	for offset in tile.offsets:
		var slot_offsset : Vector2i = tile_pos + offset
		var slot : AbilityGridSlot = grid_coords.get(slot_offsset)
		for direction in directions:
			var neighbor : Vector2i = slot_offsset + direction
			var neighbor_slot : AbilityGridSlot = grid_coords.get(neighbor)
			if neighbor_slot != null:
				if neighbor_slot.occupied_by == tile:
					continue
				elif neighbor_slot.occupied_by != null:
					adjacent_tiles[neighbor] = (neighbor_slot.occupied_by)
				pass
			pass
	return adjacent_tiles

func get_adjacent_tiles_from_adjacent_points(tile : AbilityTile) -> Dictionary[Vector2i, AbilityTile]: 
	if !ability_tiles.has(tile):
		return {}
	
	var adjacent_tiles : Dictionary[Vector2i, AbilityTile] = {}
	
	var tile_pos : Vector2i = ability_tiles.get(tile)
	
	var directions : Array[Vector2i] = [Vector2i(1,0), Vector2i(-1,0), Vector2i(0,1), Vector2i(0,-1)]
	
	for point in tile.adjacent_points:
		var slot_offsset : Vector2i = tile_pos + point
		var slot : AbilityGridSlot = grid_coords.get(slot_offsset)
		if slot != null:
			if slot.occupied_by != null and slot.occupied_by != tile:
				adjacent_tiles[slot_offsset] = slot.occupied_by
		pass
	pass
	return adjacent_tiles
