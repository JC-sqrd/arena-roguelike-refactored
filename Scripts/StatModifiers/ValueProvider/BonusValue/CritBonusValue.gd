class_name CritBonusValue extends BonusValue

@export var crit_chance_stat_id : StringName = "crit_chance"
@export var crit_multiplier : float = 2

var crit_chance : float = 0

func get_bonus_value(value : float, context : Dictionary[StringName, Variant]) -> float:
	var stats : Stats = context["actor_stats"]
	var crit_chance_stat : Stat = stats.get_stat(crit_chance_stat_id)
	
	if crit_chance_stat == null:
		printerr("Actor " + str(stats) + " does not contain the stat id: " + crit_chance_stat_id)
		return 0
	else:
		crit_chance = crit_chance_stat.get_value()
	
	if crit_chance >= randf():
		print("CRIT!")
		return value * crit_multiplier
	return 0
