class_name ArenaUI extends Control

@export var ability_shop_item_pool : AbilityTileShopItemPool

@onready var player_ui: Control = %PlayerUI
@onready var hidden_layer: Control = $HiddenLayer
@onready var player_character_ui: PlayerCharacterUI = $PlayerUI/MarginContainer/PlayerCharacterUi
@onready var ui_ability_grid: AbilityGridUIController = %UiAbilityGrid
@onready var weapon_upgrade_panel: WeaponUpgradeUIPanel = %WeaponUpgradePanel
@onready var ability_grid_shop_panel: BaseAbilityGridUIController = %AbilityGridShopPanel
@onready var target_health_bar: TextureProgressBar = %TargetHealthBar

@onready var crosshair_ui: CrosshairUI = %CrosshairUI

func initialize():
	player_character_ui.initialize(PlayerServer.main_player)
	ui_ability_grid.initialize()
	weapon_upgrade_panel.initailize()
	ability_grid_shop_panel.initialize_shop_ui(ability_shop_item_pool)
	crosshair_ui.initialize()
	pass

func _ready() -> void:
	hidden_layer.visible =false

func toggle_hidden_layer_visibility():
	hidden_layer.visible = !hidden_layer.visible
	if hidden_layer.visible:
		crosshair_ui.visible = false
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		crosshair_ui.visible = true
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	pass

func open_ui():
	visible = !visible

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == KEY_TAB and event.pressed:
		toggle_hidden_layer_visibility()
		pass
