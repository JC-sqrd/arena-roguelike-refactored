class_name ItemPoolTier extends Resource

@export var tier_weight : float = 0
@export var data : Array[ItemPoolInstance]


func get_total_weight() -> float:
	var total_weight : float = 0
	for item in data:
		total_weight += item.get_weight()
	return total_weight

func get_random_item() -> ItemPoolInstance:
	var total_weight : float = get_total_weight()
	var rand : float = randf_range(0, total_weight)
	var selected_item : ItemPoolInstance
	
	for item in data:
		rand -= item.get_weight()
		if rand <= 0:
			selected_item = item
			return selected_item
	return selected_item
