class_name AbilityTileShopItemData extends ShopItemData

@export var ability_tile : AbilityTile
@export var cost : float = 0


func can_buy(currency : float) -> bool:
	if currency >= cost:
		return true
	return false

func get_cost() -> float:
	return cost
