class_name ChargeWeaponInput extends WeaponControllerInputStrategy

@export var max_charge : float = 1
@export var max_modifier : float = 1

var charging : bool = false
var charge_time : float = 0
var charge_ratio : float = 0 

func handle_input_pressed():
	reset_charge()
	charging = true
	input_modifier = max_modifier
	pass

func handle_input_released():
	charge_ratio = charge_time / max_charge
	input_modifier *= charge_ratio
	controller.start_attack()
	pass

func update(delta : float):
	if charging:
		charge_time += delta
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

func is_input_held() -> bool:
	return charging
