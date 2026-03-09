class_name ContextStatsValueProvider extends ValueProvider


var context_stats_id : StringName
var stat_id : StringName

func _init(context_stats_id : StringName, stat_id : StringName, bonus_values : Array[BonusValue] = [], multipliers : Array[ValueMultiplier] = [], adders : Array[ValueAdder] = []):
	self.context_stats_id = context_stats_id
	self.stat_id = stat_id
	self.bonus_values = bonus_values
	self.multipliers = multipliers
	self.adders = adders
	pass


func get_value(context : Dictionary[StringName, Variant] = {}) -> float:
	var stats : Stats = context[context_stats_id]
	var stat : Stat = stats.get_stat(stat_id)
	var final_value : float = 0
	final_value = stat.get_value() + calculate_bonus_value(final_value, context)
	final_value += calculate_total_adder()
	final_value *= calculate_total_multiplier()
	return final_value 
