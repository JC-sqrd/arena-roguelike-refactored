class_name FlatStatMutatorTemplate extends StatMutatorTemplate

@export var mode : FlatStatMutator.Mode = FlatStatMutator.Mode.ADD

func build_mutator(context : Dictionary[StringName, Variant]) -> FlatStatMutator:
	var flat_mutator : FlatStatMutator = FlatStatMutator.new(stat_id, value_provider_template.build_value_provider(context), required_context, mode)
	return flat_mutator
