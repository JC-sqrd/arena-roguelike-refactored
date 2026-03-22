class_name ChargeWeaponInput extends WeaponControllerInputStrategy

@export var max_charge : float = 1
@export var max_modifier : float = 1

var charging : bool = false
var charge_time : float = 0
var charge_ratio : float = 0 

func handle_input_pressed():
	charging = true
	input_modifier = max_modifier
	pass

func handle_input_released():
	charge_ratio = charge_time / max_charge
	input_modifier *= charge_ratio
	controller.start_attack()
	reset_charge()
	pass

func update(delta : float):
	if charging:
		charge_time += delta
		print("CHARGING")
		pass
	
	if charge_time >= max_charge:
		charging = false
	pass

func reset_charge():
	charging = false
	charge_ratio = 1
	input_modifier = 1
	charge_time = 0
	pass
