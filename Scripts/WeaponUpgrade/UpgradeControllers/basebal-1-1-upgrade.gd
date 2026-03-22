extends WeaponUpgradeController

@export var effect_template : EffectTemplate
@export_flags_2d_physics var coll_mask : int = 0

var effect : Effect

const TEST_ABILITY_HITBOX = preload("uid://bhyjrjxakyds1")

var hit_context : Dictionary[StringName, Variant]

func _on_initialized():
	print("UPGRADE INITIALIZED: " + str(weapon_controller))
	weapon_controller.weapon_hit.connect(_on_weapon_hit)
	pass

func _on_weapon_hit(hits : Array[RID], context : Dictionary[StringName, Variant]):
	
	effect = effect_template.build_effect(context)
	hit_context = context
	print("BASEBALL HIT")
	var hitbox : DelayHitbox = TEST_ABILITY_HITBOX.instantiate() as DelayHitbox
	hitbox.hits_queried.connect(_on_hit_queried)
	hitbox.global_position = weapon_controller.wielder.action_point
	hitbox.collision_mask = coll_mask
	hitbox.initialize()
	ArenaServer.active_arena.add_child(hitbox)
	hitbox.look_at(hitbox.get_global_mouse_position())
	pass

func _on_hit_queried(hits : Array[RID]):
	for hit in hits:
		EffectServer.receive_effect(hit, effect, hit_context)
	pass
