class_name ContextStatsValueProvider extends ValueProvider


var context_stats_id : StringName
var stat_id : StringName

func _init(context_stats_id : StringName, stat_id : StringName, bonus_values : Array[BonusValue] = []):
	self.context_stats_id = context_stats_id
	self.stat_id = stat_id
	self.bonus_values = bonus_values
	pass


func get_value(context : Dictionary[StringName, Variant] = {}) -> float:
	var stats : Stats = context[context_stats_id]
	var stat : Stat = stats.get_stat(stat_id)
	var value : float = stat.get_value()
	return value + calculate_bonus_value(value, context)
