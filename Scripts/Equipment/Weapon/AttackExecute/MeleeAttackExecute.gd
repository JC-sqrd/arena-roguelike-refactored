class_name MeleeAttackExecute extends AttackExecute

func execute(context : AttackExecuteContext):
	for query in context.queries:
		for effect in context.attack_effects:
			EffectServer.receive_effect(query, effect, context.effects_context)
	pass
