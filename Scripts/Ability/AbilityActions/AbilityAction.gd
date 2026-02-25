@abstract
class_name AbilityAction extends Node

var caster : Entity

func initialize(caster : Entity, ability : Ability):
	pass

@abstract
func do(caster : Entity, ability : Ability)
