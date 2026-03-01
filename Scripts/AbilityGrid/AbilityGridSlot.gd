class_name AbilityGridSlot extends Resource


var occupied : bool = false
var occupied_by : AbilityTile 
var grid_pos : Vector2i

func occupy(ability_tile : AbilityTile):
	occupied_by = ability_tile
	occupied = true
	pass

func unoccupy() -> AbilityTile:
	var temp : AbilityTile = occupied_by
	occupied_by = null
	occupied = false
	return temp
