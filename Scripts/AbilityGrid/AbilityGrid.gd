class_name AbilityGrid extends Resource


@export var size : Vector2i = Vector2i(5,5)
@export var initial_ability_tiles : Dictionary[Vector2i, AbilityTile]

var grid_coords : Dictionary[Vector2i, AbilityGridSlot]
var occupied_slots : Dictionary[Vector2i, AbilityGridSlot]
var ability_tiles : Dictionary[AbilityTile, Vector2i]

var initialized : bool = false

signal grid_changed()

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
			grid_coords[grid_coord] = AbilityGridSlot.new()
			pass
		pass
	initialized = true
	pass


func get_tile_on_slot(slot_pos : Vector2i) -> AbilityTile:
	var slot : AbilityGridSlot = grid_coords.get(slot_pos)
	if !slot:
		return null 
	return slot.occupied_by

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
	return true

func remove_tile_on_slot(grid_pos : Vector2i) -> AbilityTile:
	if !grid_coords.has(grid_pos):
		return null
	
	var ability_tile : AbilityTile = grid_coords[grid_pos].occupied_by
	
	if !ability_tile:
		return null
	
	for offset in ability_tile.offsets:
		var slot_offsset : Vector2i = grid_pos + offset
		var slot : AbilityGridSlot = grid_coords.get(slot_offsset)
		occupied_slots.erase(slot_offsset)
		slot.occupied = false
		slot.occupied_by = null
		pass
	
	ability_tiles.erase(ability_tile)
	return ability_tile
