class_name ProjectileWeaponMuzzleAnim2D extends AnimatedSprite2D


var projectile_weapon_controller : ProjectileWeaponController

func initialize(controller : ProjectileWeaponController):
	#projectile_weapon_controller = controller
	controller.attack_started.connect(_on_weapon_attack_started)
	#controller.attack_end.connect(_on_weaon_attack_end)
	animation_finished.connect(_on_animation_finished)
	pass

func _on_weapon_attack_started():
	stop()
	play("muzzle")
	pass

func _on_animation_finished():
	play("default")
	pass
