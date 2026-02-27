class_name CritBonusValue extends BonusValue

@export var value_provider_template : ValueProviderTemplate
@export var crit_multiplier : float = 2

var crit_chance : float = 0
var value_provider : ValueProvider

func get_bonus_value(value : float, context : Dictionary[StringName, Variant]) -> float:
	var stats : Stats = context["source_stats"]
	#var crit_chance_stat : Stat = stats.get_stat(crit_chance_stat_id)
	value_provider = value_provider_template.build_value_provider(context)
	crit_chance = value_provider.get_value(context)
	
	#if crit_chance_stat == null:
	#	printerr("Actor " + str(stats) + " does not contain the stat id: " + crit_chance_stat_id)
	#	return 0
	#else:
	#	crit_chance = crit_chance_stat.get_value()
	
	if crit_chance >= randf():
		print("CRIT!: " + str(crit_chance * 100) + "%")
		return value * crit_multiplier
	return 0
