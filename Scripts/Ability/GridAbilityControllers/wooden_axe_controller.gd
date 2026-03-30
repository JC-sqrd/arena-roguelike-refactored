extends GridAbilityController

@export var effect_templates : Array[EffectTemplate]
@export_flags_2d_physics var coll_mask : int = 0
var weapon_controller : WeaponController

const TEST_ABILITY_HITBOX = preload("uid://bhyjrjxakyds1")

var hitbox : HitBox

var hit_threshold : int = 15
var _hit_counter : int = 0

func _on_initialized():
	EventServer.weapon_hit.connect(_on_weapon_hit)
	pass

func _on_weapon_equipped(weapon : Weapon):
	weapon_controller = weapon.get_active_controller()
	active = true
	pass

func _on_weapon_unequipped(weapon : Weapon):
	active = false
	pass

func _on_weapon_hit(hit : RID, effects : Array[Effect],context : Dictionary[StringName, Variant]):
	if context.source != caster:
		return

	var effect_value : float = 0
	
	for effect in effects:
		if effect.effect_id == "damage_effect":
			var damage_effect : Effect = effect
			effect_value = damage_effect.mutator.value_provider.get_value(damage_effect.effect_context)
			break
		pass
	
	var value_provider : FlatValueProvider = FlatValueProvider.new(effect_value * 0.8)
	var mutator : FlatStatMutator = FlatStatMutator.new("current_health", value_provider, [])
	var instant_effect : InstantEffect = InstantEffect.new(mutator, "damage_effect")
	
	
	instant_effect.effect_context = context
	instant_effect.effect_events.append(DamageEffectEventTemplate.new())
	mutator.mode = mutator.Mode.SUBTRACT
	
	#hit_effects = 
	_hit_counter += 1
	
	
	if _hit_counter >= hit_threshold:
		hitbox = TEST_ABILITY_HITBOX.instantiate() as DelayHitbox
		self.effects = [instant_effect]
		hitbox.hits_queried.connect(_on_hit_queried)
		hitbox.global_position = caster.action_point
		hitbox.collision_mask = coll_mask
		hitbox.initialize()
		ArenaServer.active_arena.add_child(hitbox)
		hitbox.look_at(hitbox.get_global_mouse_position())
		_hit_counter = 0
	pass

func _on_hit_queried(hits : Array[RID]):
	for hit in hits:
		var ability_effects : Array[Effect] = generate_effects()
		for effect in ability_effects:
			EffectServer.receive_effect(hit, effect, controller_context)
	controller_context.clear()
	pass


func _exit_tree() -> void:
	EventServer.weapon_hit.disconnect(_on_weapon_hit)
	pass
