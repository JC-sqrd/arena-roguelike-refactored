extends GridAbilityController

@export var effect_template : EffectTemplate
@export var hit_threshold : int = 5

const SWORD_HITBOX = preload("uid://c76vs1hc7dibt")

var _hit_counter : int = 0 

func _on_initialized():
	EventServer.weapon_attack_started.connect(_on_weapon_attack_started)
	hit_threshold -= min(level, hit_threshold)
	pass

func _on_weapon_attack_started(weapon_controller : WeaponController):
	_hit_counter += 1
	
	if _hit_counter >= hit_threshold:
		_hit_counter = 0
		var hitbox : DelayHitbox = SWORD_HITBOX.instantiate() as DelayHitbox
		var rand_offset : Vector2 = Vector2(randf_range(-10, 10), randf_range(-10, 10))
		hitbox.global_position = caster.global_position + rand_offset
		var angle : float = (caster.global_position.direction_to(ArenaServer.active_arena.get_global_mouse_position())).angle()
		hitbox.rotate(angle)
		ArenaServer.active_arena.add_child(hitbox)
		hitbox.hits_queried.connect(_on_hitbox_hits_queried)
	pass

func _on_hitbox_hits_queried(hits : Array[RID]):
	var context : Dictionary[StringName, Variant] = generate_controller_context()
	for hit in hits:
		EffectServer.receive_effect(hit, effect_template.build_effect(context), context)
		pass
	pass
