extends Node


var active_cooldowns : Array[CooldownTimer]

func start_cooldown_timer(timer : CooldownTimer):
	active_cooldowns.append(timer)
	pass

func _process(delta: float) -> void:
	for timer in active_cooldowns:
		if timer.active:
			timer._update(delta)
		else:
			active_cooldowns.erase(timer)
		pass
	pass
