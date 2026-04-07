class_name AbilityTileShopItemPool extends ItemPool

@export var data : ItemPoolType


func get_random_item() -> Variant:
	return data.get_random_item()
