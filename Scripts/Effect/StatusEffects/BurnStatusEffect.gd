class_name Burn extends StatusEffect


var _time_counter : float = 0
var stack : int = 1


func apply_effect(stats : Stats):
	super(stats)

func update(delta : float):
	_time_counter += delta
	if _time_counter >= 1:
		_time_counter = 0
		
		target_stats.get_stat("current_health").add(-1 * stack, effect_context)
		invoke_effect_events()
		_apply_status_effect(target_stats)
		pass
	pass

func _apply_status_effect(stats : Stats):
	pass

func add_stack(amount : int):
	stack += amount

func _on_status_effect_applied():
	pass
