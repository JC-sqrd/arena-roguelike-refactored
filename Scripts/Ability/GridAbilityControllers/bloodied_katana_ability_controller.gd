extends GridAbilityController

const BLOODIED_KATANA_HITBOX = preload("uid://casq1sr6w85ns")

@export var area_template : AreaTemplate
@export_flags_2d_physics var collision_mask_layer : int
var hitbox : HitBox
var area : Area

@export var effect_templates : Array[EffectTemplate]
var targets : Array[RID]


@export var cooldown : float = 0
var curr_cd : float = 0

var _curr_target : Entity
var _curr_dist_sqrd : float 
var _dist_threshold : float = 120
var _follow_speed : float = 10
var _queue_hit : bool = false

var _curr_anim_length : float = 0
var _curr_anim_pos : float = 0
var _action_time : float = 0

var _tween : Tween

var _attack : bool = false

var c_look_at_target : LookAtTarget
var c_float_around_target : FloatAroundTarget
var c_hit_at_action_time : HitAtAnimActionTime
var c_cooldown : AbilityCooldown
var c_target_detector : TargetAreaDetector

func _on_initialized():
	hitbox = BLOODIED_KATANA_HITBOX.instantiate() as HitBox
	for template in effect_templates:
		effects.append(template.build_effect(controller_context))
		pass
	
	
	area = area_template.build_area()
	get_tree().root.add_child(hitbox)
	AreaServer.register_area(caster.entity_rid, area)
	#hitbox.effects = effects
	hitbox.context = controller_context
	hitbox.collision_mask = collision_mask_layer
	hitbox.global_position = caster.global_position
	
	c_target_detector = TargetAreaDetector.new(area)
	c_look_at_target = LookAtTarget.new(hitbox)
	c_float_around_target = FloatAroundTarget.new(hitbox)
	c_hit_at_action_time = HitAtAnimActionTime.new(hitbox)
	pass

func _process(delta: float) -> void:
	if !active:
		return
	
	
	if c_target_detector.targets.size() > 0:
		curr_cd += delta
	
	if curr_cd >= cooldown:
		
		curr_cd = 0
		
		c_target_detector.targets.sort_custom(
			func(a, b):
				var dist_a : float = EntityServer.active_entities[a].global_position.distance_squared_to(hitbox.global_position)
				var dist_b : float = EntityServer.active_entities[b].global_position.distance_squared_to(hitbox.global_position)
				return dist_a < dist_b
		)
		
		c_look_at_target.look_at_closest_target(c_target_detector.targets)
		
		hitbox.anim_player.play("bloody_strike")
		_curr_anim_length = hitbox.anim_player.current_animation_length
		_action_time = _curr_anim_length * 0.3
		
		_queue_hit = true
	
	
	if c_hit_at_action_time.listen_for_anim("bloody_strike", 0.3, _queue_hit):
		start_ability()
		_queue_hit = false
	
	c_target_detector.update_position(caster.global_position)


func start_ability():
	var hits : Array[RID] = hitbox.query_hits() 
	for hit in hits:
		var effects : Array[Effect]
		var context : Dictionary[StringName, Variant] = generate_controller_context() 
		for template in effect_templates:
			effects.append(template.build_effect(context))
		for effect in effects:
			EventServer.weapon_hit.emit(hits, effects, context)
			EffectServer.receive_effect(hit, effect, context)
	pass


func _physics_process(delta: float) -> void:
	if !active:
		return
	
	c_float_around_target.float_around_target(caster.global_position, delta)
	pass

func _exit_tree() -> void:
	hitbox.queue_free()
	c_target_detector.area.free_area()
	pass


func rads_to_deg(rad : float) -> float:
	return rad * (180 / PI)
