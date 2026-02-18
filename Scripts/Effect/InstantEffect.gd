class_name InstantEffect extends Effect

var flat_mutators : Array[FlatStatMutator]

func _init(mutators : Array[StatMutator] = []):
	self.mutators = mutators
	pass

func apply_effect(stats : Stats, context : Dictionary[StringName, Variant] = {}):
	for block_tag in block_tags:
		if stats.has_tag(block_tag):
			return
	
	for applied_tag in applied_tags:
		stats.add_tag(applied_tag)
		pass
	
	for mutator in mutators:
		if stats.has(mutator.stat_id):
			mutator.apply_mutator(stats.get_stat(mutator.stat_id), context)
			pass
		else:
			continue
	pass
