@abstract
class_name AbilityAction extends Node

var caster : Entity

func initialize(caster : Entity, controller : AbilityController):
	pass

@abstract
func do(caster : Entity, context : Dictionary[StringName, Variant])


func _exit_tree() -> void:
	caster = null
