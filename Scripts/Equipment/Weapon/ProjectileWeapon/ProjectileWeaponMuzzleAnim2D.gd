class_name ProjectileWeaponMuzzleAnim2D extends AnimatedSprite2D


var projectile_weapon_controller : ProjectileWeaponController
@export var timer : Timer

func initialize(controller : ProjectileWeaponController):
	#projectile_weapon_controller = controller
	controller.attack_started.connect(_on_weapon_attack_started)
	controller.attack_end.connect(_on_weaon_attack_end)
	#animation_finished.connect(_on_animation_finished)
	timer.wait_time = 0.2
	timer.timeout.connect(_on_timeout)
	pass

func _on_weapon_attack_started():
	if !(animation == "muzzle"):
		sprite_frames.set_animation_loop("muzzle", true)
		play("muzzle")
	pass

func _on_weaon_attack_end():
	timer.start()
	pass

func _on_timeout():
	sprite_frames.set_animation_loop("muzzle", false)
	play("default")
	pass
