class_name AbilityTileShopItemPoolInstance extends ItemPoolInstance


@export var item_shop_data : AbilityTileShopItemData
@export var weight : float = 0

func get_instance_data() -> AbilityTileShopItemData:
	return item_shop_data

func get_weight() -> float:
	return weight
