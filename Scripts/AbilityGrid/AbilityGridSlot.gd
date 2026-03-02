class_name AbilityGridSlot extends GridSlot

var occupied_by : AbilityTile 


func occupy(ability_tile : AbilityTile):
	occupied_by = ability_tile
	occupied = true
	pass

func unoccupy() -> AbilityTile:
	var temp : AbilityTile = occupied_by
	occupied_by = null
	occupied = false
	return temp
