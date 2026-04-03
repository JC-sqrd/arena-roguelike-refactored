#Ground Slam Ability Controller
extends ActiveAbilityController
@export var effect_templates : Array[EffectTemplate]

#Spawn A Delay a Hitbox
const GROUND_SLAM_HITBOX = preload("uid://hkn4jr4vsdqg")

func _on_initialized():
	
	pass

func _on_start():
	ability_to_execute.emit()
	var hitbox : DelayHitbox = GROUND_SLAM_HITBOX.instantiate() as DelayHitbox
	hitbox.hits_queried.connect(_on_hit_queried)
	#controller_context = generate_controller_context()
	#effects = generate_effects_from_templates(effect_templates, controller_context)
	hitbox.global_position = caster.global_position
	
	ArenaServer.active_arena.add_child(hitbox)
	hitbox.initialize()
	hitbox.query_hits(false)
	ability_executed.emit()
	end()
	pass

func _on_hit_queried(hits : Array[RID]):
	send_effects_to_hits(hits)
	pass

func send_effects_to_hits(hits : Array[RID]):
	for hit in hits:
		var ability_effects : Array[Effect] = generate_effects_from_templates(effect_templates, controller_context)
		for effect in ability_effects:
			EffectServer.receive_effect(hit, effect, controller_context)
			pass
	pass
