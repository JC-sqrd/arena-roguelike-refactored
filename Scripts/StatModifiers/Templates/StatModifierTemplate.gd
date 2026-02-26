@abstract
class_name StatModifierTemplate extends Resource

@export var stat_id : Stats.DefinedStats
@export var value_provider_template : ValueProviderTemplate
@export var required_context : Array[ContextTag]

func build_modifier(context : Dictionary[StringName, Variant]) -> StatModifier:
	return null
