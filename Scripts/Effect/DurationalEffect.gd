class_name DurationalEffect extends Effect

var flat_modifiers : Array[FlatStatModifier]
var mult_modifiers : Array[MultiplierStatModifier]
var override_modifiers : Array[OverrideStatModifier]

func _init(modifiers : Array[StatModifier]):
	self.modifiers = modifiers
	pass

func apply_effect(stats : Stats, context : Dictionary = {}):
	for modifier in modifiers:
		if stats.has(modifier.stat_id):
			modifier.apply_modifier(stats.get_stat(modifier.stat_id))
			pass
		else:
			continue
	pass

func add_modifier(modifier : StatModifier):
	if modifier is FlatStatModifier:
		flat_modifiers.append(modifier)
		modifiers.clear()
		modifiers.append_array(flat_modifiers)
		modifiers.append_array(mult_modifiers)
		modifiers.append_array(override_modifiers)
	elif modifier is MultiplierStatModifier:
		mult_modifiers.append(modifier)
		modifiers.clear()
		modifiers.append_array(flat_modifiers)
		modifiers.append_array(mult_modifiers)
		modifiers.append_array(override_modifiers)
	else:
		override_modifiers.append(modifier)
		modifiers.clear()
		modifiers.append_array(flat_modifiers)
		modifiers.append_array(mult_modifiers)
		modifiers.append_array(override_modifiers)
	pass

func set_modifiers(modifiers : Array[StatModifier]):
	self.modifiers = modifiers
	pass
