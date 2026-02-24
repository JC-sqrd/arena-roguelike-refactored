class_name ActiveAbilityData extends AbilityData

@export_group("Ability Resource Requirement")
@export var resource_stat_id : StringName = "mana"
@export var required_amount : float = 10

#@export var ability_scene : PackedScene
#@export var ability_name : String
#@export var ability_id : StringName = "ability"
#@export var ability_icon : Texture
#@export_multiline() var ability_description : String
#@export_multiline() var ability_details : String

func build_abiltiy() -> ActiveAbility:
	var ability : ActiveAbility = ability_scene.instantiate()
	ability.ability_name = ability_name
	ability.ability_id = ability_id
	ability.ability_icon = ability_icon
	ability.ability_description = ability_description
	ability.ability_details = ability_details
	ability.resource_stat_id = resource_stat_id
	ability.required_amount = required_amount
	return ability
