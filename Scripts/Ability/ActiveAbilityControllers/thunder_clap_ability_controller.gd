#Thunder Clap Ability
extends ActiveAbilityController


const THUNDER_CLAP_HITBOX = preload("uid://c0x0eirspcmbd")

@export var damage_effect_template : InstantEffectTemplate

var _anchored : bool = false

var _hitbox : HitBox

func _process(delta: float) -> void:
	if !_anchored:
		return
	
	_hitbox.global_position = caster.action_point

func _on_start():
	print("THUNDER CLAP ABBILITY START")
	_anchored = true
	var hitbox : DelayHitbox = THUNDER_CLAP_HITBOX.instantiate() as DelayHitbox
	_hitbox = hitbox
	hitbox.to_be_freed.connect(_on_hitbox_to_be_freed)
	controller_context = generate_controller_context()
	hitbox.hits_queried.connect(_on_hit_queried)
	ArenaServer.active_arena.add_child(hitbox)
	var mouse_pos : Vector2 = ArenaServer.active_arena.get_global_mouse_position() - caster.global_position
	hitbox.rotate(mouse_pos.normalized().angle())
	hitbox.global_position = caster.action_point
	end()

func _on_hitbox_to_be_freed():
	_anchored = false

func _on_hit_queried(hits : Array[RID]):
	for hit in hits:
		EffectServer.receive_effect(hit, damage_effect_template.build_effect(controller_context), controller_context)
		pass
	pass
