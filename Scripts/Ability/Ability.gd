@abstract
class_name Ability extends Node

var ability_name : String
var ability_id : StringName
var ability_icon : Texture
var ability_description : String
var ability_details : String

var caster : Entity
var ability_context : Dictionary[StringName, Variant]

var cooldown : float = 0
var curr_cooldown : float = 0

func initialize(caster : Entity):
	self.caster = caster
	ability_context = generate_ability_context()
	_on_initialized()
	pass

func _on_initialized():
	pass

func enter_cooldown():
	pass

func reset():
	pass

func generate_ability_context() -> Dictionary[StringName, Variant]:
	return {}

func generate_ability_stats() -> Stats:
	return null
