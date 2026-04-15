class_name InstantEffect extends Effect

func _init(mutator : StatMutator, effect_id : StringName = "instant_effect"):
	self.effect_id = effect_id
	self.mutator = mutator
	pass

func apply_effect(entity : Entity):
	if _freed : return
	for block_tag in block_tags:
		if entity.stats.has_tag(block_tag):
			return
	
	for applied_tag in applied_tags:
		entity.stats.add_tag(applied_tag)
		pass
	
	if entity.stats.has(mutator.stat_id):
		mutator.apply_mutator(entity.stats.get_stat(mutator.stat_id), effect_context)
		pass
	
	applied_effect.emit(self)
	pass
