class_name AbilityCooldown extends RefCounted


var cooldown : float = 0

func _init(cooldown : float) -> void:
	self.cooldown = cooldown
	pass


func is_cooldown(curr_cooldown : float, delta : float) -> bool:
	return false
