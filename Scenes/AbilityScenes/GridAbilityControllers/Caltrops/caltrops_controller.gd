#Caltrops Controller
extends GridAbilityController


@export var lifetime_timer : Timer
@export var cooldown_timer : Timer
@export var effect_temps : Array[EffectTemplate]
@export var effect_temp : EffectTemplate
@export var travel_distance : float = 64
var on_cooldown : bool = false
const CALTROPS_HITBOX = preload("uid://biqsn0i6kju33")



var active_caltrops : Array[Array]
var moving_caltrops : Array[Array]
var stop_queue : Array[Array]
var free_queue : Array[Array]

func _on_initialized():
	EventServer.ability_start.connect(_on_ability_start)
	cooldown_timer.timeout.connect(_on_cooldown_timeout)
	lifetime_timer.timeout.connect(_on_lifetime_timeout)
	#cooldown_timer.start()
	pass

func _process(delta: float) -> void:
	if active_caltrops.is_empty():
		return
	
	if !((Engine.get_process_frames() % 2) == 0):
		return
	
	for data in free_queue:
		data[0].queue_free()
		moving_caltrops.erase(data)
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

func _physics_process(delta: float) -> void:
	if moving_caltrops.is_empty():
		return
	
	for data in stop_queue:
		moving_caltrops.erase(data)
		pass
	stop_queue.clear()
	
	for data in moving_caltrops:
		var hitbox : HitBox = data[0]
		var dir : Vector2 = data[2]
		var target_pos : Vector2 = data[3]
		data[0].global_position = lerp(hitbox.global_position , target_pos, delta)
		if hitbox.global_position.distance_squared_to(target_pos) <= 5:
			stop_queue.append(data)
			pass
		pass
	
	pass

func _on_ability_start(controller : AbilityController, context : Dictionary[StringName, Variant]):
	var active_ability_tag : bool = context.get("active_ability")
	if !active_ability_tag:
		return
	print("CAST CALTROPS")
	start_ability()
	pass

func _on_start_ability():
	if on_cooldown:
		return
	
	var amount : int = 3 + (level - 1)
	print("CALTROPS AMOUNT: ", amount)
	var angle_deg : float = 360 / amount
	for i in range(amount):
		var hitbox : HitBox = CALTROPS_HITBOX.instantiate() as HitBox
		var hits : int = 1 
		var dir : Vector2 = Vector2.from_angle(deg_to_rad(angle_deg * i)).normalized()
		var target_pos : Vector2 = caster.global_position + (dir * travel_distance)
		hitbox.global_position = caster.global_position
		ArenaServer.active_arena.add_child(hitbox)
		var data : Array[Variant] = [hitbox, hits, dir, target_pos]
		moving_caltrops.append(data)
		active_caltrops.append(data)
	
	lifetime_timer.start()
	cooldown_timer.start()
	on_cooldown = true
	pass
	
func _on_lifetime_timeout():
	for data in active_caltrops:
		data[0].queue_free()
	for data in moving_caltrops:
		data[0].queue_free()
	for data in free_queue:
		data[0].queue_free()
	for data in stop_queue:
		data[0].queue_free()
	moving_caltrops.clear()
	active_caltrops.clear()
	free_queue.clear()
	stop_queue.clear()
	pass

func _on_cooldown_timeout():
	on_cooldown = false
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

func _on_exit_tree():
	for data in active_caltrops:
		data[0].queue_free()
	for data in moving_caltrops:
		data[0].queue_free()
	for data in free_queue:
		data[0].queue_free()
	for data in stop_queue:
		data[0].queue_free()
	
	active_caltrops.clear()
	moving_caltrops.clear()
	free_queue.clear()
	stop_queue.clear()
	EventServer.ability_start.disconnect(_on_ability_start)
