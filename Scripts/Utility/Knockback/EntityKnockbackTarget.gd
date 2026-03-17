class_name EntityKnockbackTarget extends KnockbackTarget

func _init(entity : Entity):
	self.entity = entity
	pass

var entity : Entity

func apply_knockback(force : Vector2):
	entity.global_position += force

func is_target_valid() -> bool:
	return is_instance_valid(entity)
	pass
