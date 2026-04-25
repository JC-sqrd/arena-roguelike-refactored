#Bomb Grid Ability Controller
extends GridAbilityController

@export var cooldown_timer : Timer

@export var effect_temp : EffectTemplate

var active_bombs : Array[Array]

const BOMB_PROJECTILE = preload("uid://c1rvtco07n3rr")
const BOMB_HITBOX = preload("uid://chx03c8o6ei7w")

var _knockback_source : Vector2

func _on_initialized():
	cooldown_timer.timeout.connect(_on_cooldown_timeout)
	cooldown_timer.start()
	pass

func _on_start_ability():
	var bomb : AnimatedSprite2D = BOMB_PROJECTILE.instantiate()
	var fuse_timer : Timer = Timer.new() 
	var bomb_data : Array[Variant] = [bomb, fuse_timer]
	fuse_timer.timeout.connect(_on_fuse_timeout)
	bomb.global_position = caster.global_position
	active_bombs.append(bomb_data)
	
	add_child(fuse_timer)
	fuse_timer.start(3)
	ArenaServer.active_arena.add_child(bomb)
	pass

func _on_fuse_timeout():
	var data : Array = active_bombs.pop_front()
	var bomb : AnimatedSprite2D = data[0]
	var timer : Timer = data[1]
	var hitbox : DelayHitbox = BOMB_HITBOX.instantiate() as DelayHitbox
	
	_knockback_source = bomb.global_position
	hitbox.global_position = bomb.global_position
	hitbox.hits_queried.connect(receive_hits)
	ArenaServer.active_arena.add_child(hitbox)

	bomb.queue_free()
	timer.queue_free()
	pass

func receive_hits(hits : Array[RID]):
	var context : Dictionary[StringName, Variant] = generate_controller_context()
	context["knockback_source"] = _knockback_source
	for hit in hits:
		EffectServer.receive_effect(hit, effect_temp.build_effect(context), context)
		pass
	pass

func _on_cooldown_timeout():
	start_ability()
	cooldown_timer.start()
	pass

func get_current_cooldown() -> float:
	return cooldown_timer.time_left

func set_current_cooldown(cd : float):
	if cooldown_timer.is_stopped():
		cooldown_timer.wait_time = cd
	else:
		cooldown_timer.stop()
		cooldown_timer.start(cd)


func _exit_tree() -> void:
	for data in active_bombs:
		data[0].queue_free()
		data[1].queue_free()
	active_bombs.clear()
	pass
