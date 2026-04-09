class_name CritChanceValueMultiplier extends ValueMultiplier

@export var crit_chance_value_provider_template : ValueProviderTemplate

func get_value(context : Dictionary[StringName, Variant]) -> float:
	var stats : Stats = context["source_stats"]
	var value_provider : ValueProvider = crit_chance_value_provider_template.build_value_provider(context)
	var crit_chance : float = value_provider.get_value(context)
	
	if crit_chance >= randf():
		context["is_critical"] = true
		print("CRIT!: " + str(crit_chance * 100) + "%")
		return value
	
	return 0
