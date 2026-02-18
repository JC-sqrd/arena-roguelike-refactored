class_name ConditionalValueProvider extends ValueProvider

enum Type {GREATER_THAN, LESSER_THAN}
var conditional_stat_id : StringName
var threshold : float = 0
var type : Type = Type.GREATER_THAN

func get_value(context : Dictionary = {}) -> float:
	var stat : Stat = (context["target_stats"] as Stats).get_stat(conditional_stat_id)
	if !stat:
		return value
	if type == Type.GREATER_THAN:
		if stat.get_value() > threshold:
			return value + bonus_value
	else:
		if stat.get_value() < threshold:
			return value + bonus_value
	return value
