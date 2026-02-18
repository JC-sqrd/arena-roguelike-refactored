class_name WeaponStatValueProvider extends ValueProvider

var stat_id : StringName

func _init(stat_id : StringName, bonus_values : Array[BonusValue] = []):
	self.stat_id = stat_id
	self.bonus_values = bonus_values
	pass

func get_value(context : Dictionary[StringName, Variant] = {}) -> float:
	var weapon_stats : Stats = context["weapon_stats"] as Stats
	var value : float = weapon_stats.get_stat(stat_id).get_value()
	return value + calculate_bonus_value(value, context)
