@abstract
class_name StatMutatorTemplate extends Resource

@export var stat_id : StringName
@export var value_provider_template : ValueProviderTemplate
@export var required_context : Array[ContextTag]

@abstract func build_mutator(context : Dictionary[StringName, Variant]) -> StatMutator
