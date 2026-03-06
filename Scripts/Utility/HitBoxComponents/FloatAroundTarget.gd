class_name FloatAroundTarget extends HitboxComponent

var target : Vector2
var hitbox : HitBox
var dist_threshold : float = 120
var follow_speed : float = 100

func _init(hitbox : HitBox):
	self.hitbox = hitbox
	pass


func float_around_target(target : Vector2, delta : float):
	hitbox.global_position = lerp(hitbox.global_position, target - ((target - hitbox.global_position).normalized() * dist_threshold), delta * follow_speed)
	pass
