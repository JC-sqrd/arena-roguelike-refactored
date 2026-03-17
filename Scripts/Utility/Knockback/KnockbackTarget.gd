class_name KnockbackTarget extends RefCounted

var global_position : Vector2

func apply_knockback(force : Vector2):
	global_position += force
	pass

func is_target_valid() -> bool:
	return true
