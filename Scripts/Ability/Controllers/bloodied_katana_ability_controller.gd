extends GridAbilityController

const BLOODIED_KATANA_HITBOX = preload("uid://casq1sr6w85ns")

@export var area_template : AreaTemplate
@export_flags_2d_physics var collision_mask_layer : int
var hitbox : HitBox
var area : Area

@export var effect_templates : Array[EffectTemplate]
var effects : Array[Effect]
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

func _on_grid_ability_controller_initialize():
	hitbox = BLOODIED_KATANA_HITBOX.instantiate() as HitBox
	for template in effect_templates:
		effects.append(template.build_effect(controller_context))
		pass
	
	area = area_template.build_area()
	area.set_area_enter_callback(_area_callback)
	get_tree().root.add_child(hitbox)
	hitbox.effects = effects
	hitbox.collision_mask = collision_mask_layer
	hitbox.global_position = caster.global_position
	pass

func _process(delta: float) -> void:
	if !active:
		return
	
	if targets.size() == 0:
		return
	
	curr_cd += delta
	if curr_cd >= cooldown:
		
		curr_cd = 0
		
		targets.sort_custom(
			func(a, b):
				var dist_a : float = EntityServer.active_entities[a].global_position.distance_squared_to(hitbox.global_position)
				var dist_b : float = EntityServer.active_entities[b].global_position.distance_squared_to(hitbox.global_position)
				return dist_a < dist_b
		)
		
		if targets.size() > 0:
			_curr_target = EntityServer.active_entities[targets[0]]
			_tween = create_tween()
			_tween.bind_node(hitbox)
			_tween.tween_property(hitbox, "rotation", Vector2.RIGHT.angle_to(_curr_target.global_position - hitbox.global_position), 0.1)
			#hitbox.look_at(_curr_target.global_position)
		
		hitbox.anim_player.play("bloody_strike")
		_curr_anim_length = hitbox.anim_player.current_animation_length
		_action_time = _curr_anim_length * 0.3
		
		_queue_hit = true
	
	if hitbox.anim_player.is_playing() and _queue_hit:
		_curr_anim_pos = hitbox.anim_player.current_animation_position
		if _curr_anim_pos >= _action_time:
			start_ability()
			_queue_hit = false
			pass
		pass
	
	
	#hitbox.rotation = lerp(hitbox.rotation, 0.0, delta * 20)
	AreaServer.set_area_position(area, caster.global_position)

func _look_at_target():
	hitbox.look_at(_curr_target.global_position)
	pass

func start_ability():
	hitbox.query_hitbox()
	pass

func _physics_process(delta: float) -> void:
	if !active:
		return

	
	hitbox.global_position = lerp(hitbox.global_position, caster.global_position - ((caster.global_position - hitbox.global_position).normalized() * _dist_threshold), delta * _follow_speed)
	#hitbox.global_position = caster.global_position
	
	_curr_dist_sqrd = hitbox.global_position.distance_squared_to(caster.global_position)
	pass
	
#1. an integer status: either AREA_BODY_ADDED or AREA_BODY_REMOVED depending on whether the other area's shape entered or exited the area,
#
#2. an RID area_rid: the RID of the other area that entered or exited the area,
#
#3. an integer instance_id: the ObjectID attached to the other area,
#
#4. an integer area_shape_idx: the index of the shape of the other area that entered or exited the area,
#
#5. an integer self_shape_idx: the index of the shape of the area where the other area entered or exited.

func _area_callback(status : int, area_rid : RID, instance_id : int, area_shape_idx : int, self_shape_idx : int):
	#Area Entered
	if status == 0:
		targets.append(area_rid)
		pass
	else:
		if targets.has(area_rid):
			targets.erase(area_rid)
		if targets.size() == 0:
			hitbox.look_at(hitbox.global_position + Vector2.RIGHT)
			pass
	pass

func _exit_tree() -> void:
	hitbox.queue_free()
	area.free_area()
	pass


func rads_to_deg(rad : float) -> float:
	return rad * (180 / PI)
