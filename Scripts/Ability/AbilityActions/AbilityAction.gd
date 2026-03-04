@abstract
class_name AbilityAction extends Node

var caster : Entity

func initialize(caster : Entity, context : Dictionary[StringName, Variant]):
	pass

@abstract
func do(caster : Entity, context : Dictionary[StringName, Variant])
