extends GridAbilityController

@export var effect_templates : Array[EffectTemplate]
@export_flags_2d_physics var coll_mask : int = 0
var weapon_controller : WeaponController

const TEST_ABILITY_HITBOX = preload("uid://bhyjrjxakyds1")

var hitbox : HitBox
var effects : Array[Effect]

var hit_threshold : int = 5
var _hit_counter : int = 0

func _on_initialized():
	
	for template in effect_templates:
		effects.append(template.build_effect(controller_context))
		pass
	
	EventServer.weapon_hit.connect(_on_weapon_hit)
	
	#caster.equipment_manager.weapon_equipped.connect(_on_weapon_equipped)
	
	#var active_controller : WeaponController
	#active_controller = caster.equipment_manager.equipped_weapon.get_active_controller()
	#if active_controller != null:
		#weapon_controller = active_controller
		#weapon_controller.weapon_hit.connect(_on_weapon_hit)
		#pass
	pass

func _on_weapon_equipped(weapon : Weapon):
	weapon_controller = weapon.get_active_controller()
	active = true
	pass

func _on_weapon_unequipped(weapon : Weapon):
	active = false
	pass

func _on_weapon_hit(hits : Array[RID], context : Dictionary[StringName, Variant]):
	if context.source != caster:
		return
	var weapon_stats : Stats = context.weapon_stats
	var weapon_damage : Stat = weapon_stats.get_stat("weapon_damage")
	var value_provider : FlatValueProvider = FlatValueProvider.new(weapon_damage.get_value() * 0.8)
	var flat_mutator : FlatStatMutator = FlatStatMutator.new("current_health", value_provider, [])
	var instant_effect : InstantEffect = InstantEffect.new([flat_mutator])
	flat_mutator.mode = flat_mutator.Mode.SUBTRACT
	instant_effect.effect_context = context
	
	_hit_counter += 1
	
	var hit_effects : Array[Effect] = [instant_effect]
	
	if _hit_counter >= hit_threshold:
		hitbox = TEST_ABILITY_HITBOX.instantiate() as DelayHitbox
		hitbox.effects = hit_effects
		hitbox.context = controller_context
		hitbox.global_position = caster.action_point
		hitbox.collision_mask = coll_mask
		hitbox.initialize()
		ArenaServer.active_arena.add_child(hitbox)
		hitbox.look_at(hitbox.get_global_mouse_position())
		_hit_counter = 0
	pass
