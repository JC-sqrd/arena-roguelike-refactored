class_name PlayerCharacterUI extends Control

@onready var active_ability_1ui: ActiveAbilityUI = %ActiveAbility1UI
@onready var active_ability_2ui: ActiveAbilityUI = %ActiveAbility2UI
@onready var active_ability_3ui: ActiveAbilityUI = %ActiveAbility3UI
@onready var player_health_bar: PlayerHealthBar = %PlayerHealthBar


var player_controller : PlayerController

func initialize(player_character : PlayerController):
	self.player_controller = player_character
	
	var ability_1_data : ActiveAbilityData = player_controller.active_ability_controller_manager.ability_one
	active_ability_1ui.initialize(ability_1_data.get_active_ability_controller(), "active_ability_1",ability_1_data.ability_icon)
	
	
	var ability_2_data : ActiveAbilityData = player_controller.active_ability_controller_manager.ability_two
	active_ability_2ui.initialize(ability_2_data.get_active_ability_controller(), "active_ability_2", ability_2_data.ability_icon)
	
	var ability_3_data : ActiveAbilityData = player_controller.active_ability_controller_manager.ability_three
	active_ability_3ui.initialize(ability_3_data.get_active_ability_controller(), "active_ability_3", ability_3_data.ability_icon)
	
	player_health_bar.initialize(player_character.player_entity.entity)
	pass
