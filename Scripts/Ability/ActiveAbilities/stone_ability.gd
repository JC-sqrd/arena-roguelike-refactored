extends ActiveAbility


@onready var spawn_projectile_ability_action: SpawnProjectileAbilityAction = %SpawnProjectileAbilityAction

func initialize(caster : Entity):
	super(caster)
	spawn_projectile_ability_action.initialize(caster, ability_context)
	pass

func start():
	execute()
	pass

func execute():
	spawn_projectile_ability_action.do(caster, ability_context)
	end()
	pass

func end():
	ability_finished.emit(self)
	pass
