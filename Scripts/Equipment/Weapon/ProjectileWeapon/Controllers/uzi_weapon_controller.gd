extends ProjectileWeaponController

@export var muzzle_particle : ProjectileWeaponMuzzleAnim2D

func _on_initialized():
	super()
	muzzle_particle.initialize(self)
