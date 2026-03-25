class_name ProjectileWeaponMuzzleParticle2D extends GPUParticles2D


var projectile_weapon_controller : ProjectileWeaponController

func initialize(controller : ProjectileWeaponController):
	#projectile_weapon_controller = controller
	controller.attack_started.connect(_on_weapon_attack_started)
	#controller.attack_end.connect(_on_weaon_attack_end)
	pass

func _on_weapon_attack_started():
	print("EMIT MUZZEL PARTICLES")
	restart()
	emitting = true
	pass
