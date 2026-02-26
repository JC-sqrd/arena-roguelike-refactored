class_name InstantEffect extends Effect

func _init(mutators : Array[StatMutator] = []):
	self.mutators = mutators
	pass

func apply_effect(stats : Stats):
	for block_tag in block_tags:
		if stats.has_tag(block_tag):
			return
	
	for applied_tag in applied_tags:
		stats.add_tag(applied_tag)
		pass
	
	for mutator in mutators:
		if stats.has(mutator.stat_id):
			mutator.apply_mutator(stats.get_stat(mutator.stat_id), effect_context)
			pass
		else:
			continue
	pass
