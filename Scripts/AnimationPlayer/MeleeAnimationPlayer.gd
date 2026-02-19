@tool
class_name MeleeAnimationPlayer extends AnimationPlayer

func _init():
	var anim_lib : AnimationLibrary
	if has_animation_library(""):
		anim_lib = get_animation_library("")
	else:
		anim_lib = AnimationLibrary.new()
		add_animation_library("", anim_lib)
	
	if not anim_lib.has_animation("windup"):
		var windup_anim : Animation = Animation.new()
		anim_lib.add_animation("windup", windup_anim)
		pass
	if not anim_lib.has_animation("attack"):
		var anim : Animation = Animation.new()
		anim_lib.add_animation("attack", anim)
		pass
	if not anim_lib.has_animation("recovery"):
		var anim : Animation = Animation.new()
		anim_lib.add_animation("recovery", anim)
		pass
	pass
