@abstract
class_name AbilityData extends Resource


@export var ability_scene : PackedScene
@export var ability_name : String
@export var ability_id : StringName = "ability"
@export var ability_icon : Texture
@export_multiline() var ability_description : String
@export_multiline() var ability_details : String


func build_abiltiy() -> Ability:
	return null
