class_name PlayerCharacterUI extends Control

@onready var ability_1_icon: AbilityIconUI = %Ability1Icon
@onready var ability_2_icon: AbilityIconUI = %Ability2Icon

var player_controller : PlayerController

func initialize(player_character : PlayerController):
	self.player_controller = player_character
	
	var ability_1_data : ActiveAbilityData = player_controller.active_ability_controller_manager.ability_one
	ability_1_icon.initialize(ability_1_data.get_active_ability_controller(), ability_1_data.ability_icon)
	
	
	var ability_2_data : ActiveAbilityData = player_controller.active_ability_controller_manager.ability_two
	ability_2_icon.initialize(ability_2_data.get_active_ability_controller(), ability_2_data.ability_icon)
	pass
