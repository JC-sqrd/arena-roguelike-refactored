class_name DurationalEffect extends Effect

#var flat_modifiers : Array[FlatStatModifier]
#var mult_modifiers : Array[MultiplierStatModifier]
#var override_modifiers : Array[OverrideStatModifier]
var stackable : bool = false
var stack : int = 1
var duration : float = 0
var _duration_counter : float = 0

var expired : bool = false

signal effect_expired(effect : Effect)

func _init(modifier : StatModifier, effect_id : StringName = "durational_effect"):
	self.modifier = modifier
	self.effect_id = effect_id
	pass

func apply_effect(stats : Stats):
	if stats.has(modifier.stat_id):
		effect_context.effect_stack = stack
		modifier.apply_modifier(stats.get_stat(modifier.stat_id))
		pass
	applied_effect.emit(self)
	pass

func update(delta : float):
	if expired:
		return
	
	if _duration_counter >= duration:
		effect_expired.emit(self)
		expired = true
		return
	
	_duration_counter += delta
	pass

func add_modifier(modifier : StatModifier):
	pass

func set_modifiers(modifiers : Array[StatModifier]):
	self.modifiers = modifiers
	pass
