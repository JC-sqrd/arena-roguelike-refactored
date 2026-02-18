@abstract
class_name StatMutator extends RefCounted


var stat_id : StringName
var required_context : Array[ContextTag]
var value_provider : ValueProvider

@abstract func apply_mutator(stat : Stat, context : Dictionary = {})
