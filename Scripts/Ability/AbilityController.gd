@abstract
class_name AbilityController extends Node
var controller_context : Dictionary[StringName, Variant]

var ability_id : StringName

func initialize(caster : Entity):
	pass

func generate_controller_context() -> Dictionary[StringName, Variant]:
	var context : Dictionary[StringName, Variant] = {}
	return context
