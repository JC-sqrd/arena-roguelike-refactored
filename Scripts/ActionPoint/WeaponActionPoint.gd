class_name WeaponActionPoint extends ActionPoint


var _relative_x : Vector2
var _mouse_angle : float

func _process(delta : float):
	super(delta)
	_relative_x = (mouse_pos - global_position)
	_mouse_angle = rads_to_deg(_relative_x.angle())
	#print("RELATIVE X: " + str(_relative_x))
	print("MOUSE ANGLE: " + str(_mouse_angle))
	
	if _mouse_angle > 90 or _mouse_angle < -90:
		scale.x = -1
		pass
	else:
		scale.x = 1
	pass


func rads_to_deg(rad : float) -> float:
	return rad * (180 / PI)
