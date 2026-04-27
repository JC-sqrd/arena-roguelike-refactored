extends ProjectileAttackExecute

@export var lazer_ray : RayCast2D

func initialize(controller : WeaponController):
	super(controller)
	pass

func execute():
	
	pass

func finish_execute():
	pass

func _on_projectile_hit(hit : RID):
	projectile_hit.emit(hit)
	pass
