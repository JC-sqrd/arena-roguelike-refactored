@abstract
class_name Ability extends Node

var ability_name : String
var ability_id : StringName
var ability_icon : Texture
var ability_description : String
var ability_details : String

var caster : Entity

func initialize(caster : Entity):
	self.caster = caster
	pass


func enter_cooldown():
	pass

func reset():
	pass

func generate_ability_context() -> Dictionary[StringName, Variant]:
	return {}

func generate_ability_stats() -> Stats:
	return null
