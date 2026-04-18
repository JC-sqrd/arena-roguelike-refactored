extends GridAbilityController

@export var bonus_lethality : float = 10

func _on_initialized():
	caster.stats.get_stat("lethality").add_bonus_value(bonus_lethality * level)
	pass

func _exit_tree() -> void:
	caster.stats.get_stat("lethality").add_bonus_value(-(bonus_lethality * level))
	pass
