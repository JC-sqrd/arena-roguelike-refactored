class_name DurationalEffect extends Effect

var flat_modifiers : Array[FlatStatModifier]
var mult_modifiers : Array[MultiplierStatModifier]
var override_modifiers : Array[OverrideStatModifier]

func _init(modifier : StatModifier, effect_id : StringName = "durational_effect"):
	self.modifier = modifier
	self.effect_id = effect_id
	pass

func apply_effect(stats : Stats):
	if stats.has(modifier.stat_id):
		modifier.apply_modifier(stats.get_stat(modifier.stat_id))
		pass
	applied_effect.emit(self)
	pass

func add_modifier(modifier : StatModifier):
	pass

func set_modifiers(modifiers : Array[StatModifier]):
	self.modifiers = modifiers
	pass
