class_name KnockbackEffectEvent extends EffectEvent

var magnitude : float = 10
var direction : Vector2
var force : Vector2

func invoke_event(context : Dictionary[StringName, Variant] = {}):
	var source_vector : Vector2
	if context.has("knockback_source"):
		source_vector = context["knockback_source"]
		pass
	else:
		source_vector = context["source"].global_position
	var target : Entity = EntityServer.active_entities.get(context.target_rid)
	
	var direction = (target.global_position - source_vector).normalized()
	
	force = direction * magnitude
	
	var knockback_target : EntityKnockbackTarget = EntityKnockbackTarget.new(target)
	
	
	KnockbackServer.apply_knockback(knockback_target, force)
	var data : Dictionary[StringName, Variant]
	data["magnitude"] = magnitude
	data["direction"] = direction
	data["force"] = force
	EventServer.knockback_applied.emit(data, context)
	pass
