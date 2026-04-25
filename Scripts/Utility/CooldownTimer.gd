class_name CooldownTimer extends Resource

@export var cooldown : float = 1

var active : bool = false

var time_left : float = 0

signal cooldown_start()
signal timeout()


func start(time : float = 0):
	active = true
	if time <= 0:
		time_left = cooldown
	else:
		time_left = time
	cooldown_start.emit()
	CooldownServer.start_cooldown_timer(self)
	pass

func _update(delta : float):
	if !active:
		return
	elif active and time_left > 0:
		time_left -= delta
	elif active and time_left <= 0:
		time_left = 0
		active = false
		timeout.emit()
	else:
		return
