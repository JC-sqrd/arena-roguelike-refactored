extends GridAbilityController



func _on_initialized():
	caster.stats.get_stat("lethality").add_bonus_value(10)
	
	pass

func _exit_tree() -> void:
	
	pass
