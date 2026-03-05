extends GridAbilityController

@export var area_template : AreaTemplate
@export var stone_ability : AbilityData
@export var spawn_projectile_action : SpawnProjectileAbilityAction

var ability : ActiveAbility

@export var cooldown : float = 1
var curr_cd : float = 0

func _on_grid_ability_controller_initialize():
	spawn_projectile_action.initialize(caster, controller_context)
	print("CONTROLLER FINISHED INITIALIZING")
	pass

func start_ability():
	throw_stone()
	pass

func throw_stone():
	print("THROW STONE!")
	spawn_projectile_action.do(caster, controller_context)
	pass

func _process(delta: float) -> void:
	if !active:
		return 
	
	curr_cd += delta
	if curr_cd >= cooldown:
		curr_cd = 0
		start_ability()
	pass
