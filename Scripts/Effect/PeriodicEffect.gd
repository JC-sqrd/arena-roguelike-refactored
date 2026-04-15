class_name PeriodicEffect extends DurationalEffect

#var flat_modifiers : Array[FlatStatModifier]
#var mult_modifiers : Array[MultiplierStatModifier]
#var override_modifiers : Array[OverrideStatModifier]
var tick_rate : float = 1
var _tick_rate_counter : float = 0
var _target_entity : Entity = null

func _init(mutator : StatMutator, effect_id : StringName = "periodic_effect"):
	#self.modifier = modifier
	self.mutator = mutator
	self.effect_id = effect_id
	pass

func apply_effect(entity : Entity):
	if entity.stats.has(mutator.stat_id):
		mutator.apply_mutator(entity.stats.get_stat(mutator.stat_id))
		#mutator.apply_modifier(stats.get_stat(modifier.stat_id))
		pass
	_target_entity = entity
	applied_effect.emit(self)
	pass

func update(delta : float):
	if expired:
		return
	
	_tick_rate_counter += delta
	
	if _tick_rate_counter >= tick_rate and is_instance_valid(_target_entity):
		_tick_rate_counter = 0
		apply_effect(_target_entity)
		invoke_effect_events()
		pass
	
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

func cleanup():
	super()
	_target_entity = null
