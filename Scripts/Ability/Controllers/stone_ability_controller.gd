extends GridAbilityController

@export var area_template : AreaTemplate
@export var stone_ability : AbilityData
@export var spawn_projectile_action : SpawnProjectileAbilityAction

var ability : ActiveAbility



func _on_grid_ability_controller_initialize():
	spawn_projectile_action.initialize(caster, controller_context)
	print("CONTROLLER FINISHED INITIALIZING")
	throw_stone()
	pass

func throw_stone():
	if self != null:
		print("THROW STONE!")
		spawn_projectile_action.do(caster, controller_context)
		get_tree().create_timer(0.05).timeout.connect(throw_stone)
	pass
