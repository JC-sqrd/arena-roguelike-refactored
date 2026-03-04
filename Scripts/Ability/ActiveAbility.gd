class_name ActiveAbility extends Ability


var resource_stat_id : StringName = "mana"
var required_amount : float = 10



signal ability_finished(abiltiy : ActiveAbility)


func start():
	execute()
	pass

func execute():
	end()
	pass

func end():
	ability_finished.emit(self)
	pass

func generate_ability_context() -> Dictionary[StringName, Variant]:
	var context : Dictionary[StringName, Variant] = {}
	context["source"] = caster
	context["caster"] = caster
	context["caster_stats"] = caster.stats
	return context
