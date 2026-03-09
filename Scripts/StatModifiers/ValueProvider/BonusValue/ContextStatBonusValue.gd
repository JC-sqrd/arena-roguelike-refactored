class_name ContextStatBonusValue extends BonusValue

@export var context_stats : StringName
@export var stat_id : StringName

var value_provider : ContextStatsValueProvider

func get_bonus_value(value : float, context : Dictionary[StringName, Variant]) -> float:
	var stats : Stats = context[context_stats]
	var final_value : float = stats.get_stat(stat_id).get_value()
	final_value += calculate_total_adder()
	final_value *= calculate_total_multiplier()
	return final_value
