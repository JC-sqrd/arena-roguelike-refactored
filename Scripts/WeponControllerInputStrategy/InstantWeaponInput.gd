class_name InstantWeaponInput extends WeaponControllerInputStrategy


var held : float = false

func handle_input_pressed():
	held = true
	pass

func handle_input_released():
	held = false
	pass

func update(delta : float):
	if held:
		controller.start_attack()
	pass
