@abstract
class_name StatusEffect extends RefCounted


var status_effect_id : StringName
var target_stats : Stats

var applied_tags : Array[StringName]
var block_tags : Array[StringName]
var effect_id : StringName

var effect_events : Array[EffectEventTemplate]

var effect_context : Dictionary[StringName, Variant]

var _freed : bool = false

signal effect_expire(status_effect : StatusEffect)

func update(delta : float):
	return

func apply_effect(stats : Stats):
	target_stats = stats
	pass

func invoke_effect_events():
	#for event_template in effect_events:
		#var effect_event : EffectEvent = event_template.build_effect_event(self)
		#effect_event.invoke_event(effect_context)
		#pass
	#invoked_effect_events.emit()
	pass

func add_stack(amount : int):
	pass

func get_stack_amount() -> int :
	return 1

func is_stackable() -> bool:
	return false

func _apply_status_effect(stats : Stats):
	pass

func _on_status_effect_applied():
	pass

func cleanup():
	target_stats = null
