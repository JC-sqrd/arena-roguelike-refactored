#Caltrops Controller
extends GridAbilityController


@export var lifetime_timer : Timer
@export var cooldown_timer : Timer
@export var effect_temps : Array[EffectTemplate]
@export var effect_temp : EffectTemplate
const CALTROPS_HITBOX = preload("uid://biqsn0i6kju33")


var active_caltrops : Array[Array]
var free_queue : Array[Array]

func _on_initialized():
	cooldown_timer.timeout.connect(_on_cooldown_timeout)
	lifetime_timer.timeout.connect(_on_lifetime_timeout)
	cooldown_timer.start()
	pass

func _process(delta: float) -> void:
	if active_caltrops.is_empty():
		return
	
	if !((Engine.get_process_frames() % 2) == 0):
		return
	
	for data in free_queue:
		data[0].queue_free()
		active_caltrops.erase(data)
	free_queue.clear()
	
	for data in active_caltrops:
		var hitbox : HitBox = data[0]
		var hits : Array[RID] = hitbox.query_hits(true)
		if !hits.is_empty():
			data[1] -= 1
		if data[1] <= 0:
			free_queue.append(data)
		apply_effect_to_hits(hits)
		pass
	pass

func _on_start_ability():
	var hitbox : HitBox = CALTROPS_HITBOX.instantiate() as HitBox
	var hits : int = 3
	hitbox.global_position = caster.global_position
	ArenaServer.active_arena.add_child(hitbox)
	var data : Array[Variant] = [hitbox, hits]
	active_caltrops.append(data)
	lifetime_timer.start()
	pass
	
func _on_lifetime_timeout():
	for data in active_caltrops:
		data[0].queue_free()
	active_caltrops.clear()
	pass

func _on_cooldown_timeout():
	start_ability()
	pass

func apply_effect_to_hits(hits : Array[RID]):
	if hits.is_empty():
		return
	var context : Dictionary[StringName, Variant] = generate_controller_context()
	for hit in hits:
		for effect_temp in effect_temps:
			EffectServer.receive_effect(hit, effect_temp.build_effect(context), context)
		pass
	pass
