@abstract
class_name EffectTemplate extends Resource

@export var applied_tags : Array[StringName]
@export var block_tags : Array[StringName]

func build_effect(context : Dictionary[StringName, Variant]) -> Effect:
	return null
