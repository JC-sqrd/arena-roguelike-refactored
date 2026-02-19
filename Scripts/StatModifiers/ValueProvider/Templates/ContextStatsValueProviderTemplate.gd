class_name ContextStatsValueProviderTemplate extends ValueProviderTemplate

@export var context_stats_id : StringName
@export var stat_id : StringName

func build_value_provider(context : Dictionary[StringName, Variant]) -> ValueProvider:
		return ContextStatsValueProvider.new(context_stats_id, stat_id, bonus_values)
