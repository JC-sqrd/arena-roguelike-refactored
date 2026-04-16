class_name WeaponUpgradeUI extends PanelContainer

@onready var buy_buton: Button = %BuyButon
var upgrade_node : WeaponUpgradeNode
var upgrade_data : WeaponUpgradeData
@onready var upgrade_name_label: RichTextLabel = %UpgradeNameLabel
@onready var upgrade_details_label: RichTextLabel = %UpgradeDetailsLabel
@onready var upgrade_icon: TextureRect = %UpgradeIcon

signal attempt_to_buy(upgrade_ui : WeaponUpgradeUI)

func initialize(upgrade_node : WeaponUpgradeNode):
	self.upgrade_node = upgrade_node
	self.upgrade_data = upgrade_node.upgrade_data
	upgrade_details_label.text = upgrade_data.upgrade_details
	upgrade_name_label.text = upgrade_data.upgrade_name
	buy_buton.pressed.connect(_on_buy_button_pressed)
	pass

func _on_buy_button_pressed():
	attempt_to_buy.emit(self)
	pass
