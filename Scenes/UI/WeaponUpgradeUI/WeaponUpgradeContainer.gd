class_name WeaponUpgradeContainer extends VBoxContainer



signal attempt_to_buy_upgrade(upgrade_ui : WeaponUpgradeUI, container : WeaponUpgradeContainer)

func add_upgrade_ui(upgrade_ui : WeaponUpgradeUI):
	add_child(upgrade_ui)
	upgrade_ui.attempt_to_buy.connect(_on_attempt_to_buy_upgrade)
	pass

func _on_attempt_to_buy_upgrade(upgrade_ui : WeaponUpgradeUI):
	attempt_to_buy_upgrade.emit(upgrade_ui, self)
	pass
