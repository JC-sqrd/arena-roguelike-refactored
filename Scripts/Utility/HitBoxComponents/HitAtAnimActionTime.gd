class_name HitAtAnimActionTime extends HitboxComponent


var hitbox : HitBox

var _curr_anim_length : float
var _curr_anim_pos : float = 0 
var _action_time : float

func _init(hitbox : HitBox):
	self.hitbox = hitbox
	pass


func listen_for_anim(anim_name : StringName, anim_ratio : float, hit  : bool) -> bool:
	
	if hitbox.anim_player.current_animation == anim_name:
		if hitbox.anim_player.is_playing() and hit:
			_curr_anim_length = hitbox.anim_player.current_animation_length
			_curr_anim_pos = hitbox.anim_player.current_animation_position
			_action_time = _curr_anim_length * anim_ratio
			if _curr_anim_pos >= _action_time:
				return true
			pass
		pass
	return false
