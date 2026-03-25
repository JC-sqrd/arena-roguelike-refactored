extends ProjectileWeaponController

@export var muzzle_particle : ProjectileWeaponMuzzleParticle2D

func _on_initialized():
	super()
	muzzle_particle.initialize(self)
