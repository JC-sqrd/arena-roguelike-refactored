@abstract
class_name WeaponControllerInputStrategy extends Resource

var controller : WeaponController
var input_modifier : float = 1


func initialize(controller : WeaponController):
	self.controller = controller
	pass

@abstract
func handle_input_pressed()

@abstract
func handle_input_released()

@abstract
func update(delta : float)
