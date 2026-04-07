class_name TieredItemPoolType extends ItemPoolType

@export var tiers : Array[ItemPoolTier]

func _get_tier_total_weight() -> float:
	var total_weight : float = 0
	for tier in tiers:
		total_weight += tier.tier_weight
	return total_weight

func get_random_item() -> ItemPoolInstance:
	var total_tier_weight : float = _get_tier_total_weight()
	var rand : float = randf_range(0, total_tier_weight)
	var selected_tier : ItemPoolTier 
	
	for tier in tiers:
		total_tier_weight -= tier.tier_weight
		if total_tier_weight <= 0:
			selected_tier = tier
			break
		pass
	
	return selected_tier.get_random_item()
