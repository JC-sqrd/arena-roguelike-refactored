extends GridAbilityController

const BLOODIED_KATANA_HITBOX = preload("uid://casq1sr6w85ns")

@export var area_template : AreaTemplate
@export_flags_2d_physics var collision_mask_layer : int
var hitbox : HitBox
var area : Area

@export var effect_templates : Array[EffectTemplate]
var effects : Array[Effect]
var targets : Array[RID]


@export var cooldown : float = 1
var curr_cd : float = 0

var _curr_target : Entity
var _curr_dist_sqrd : float #Squared distance
var _dist_threshold : float = 120
var _follow_speed : float = 10
var _relative_x : Vector2
var _target_angle : float = 0
var _queue_hit : bool = false

var _curr_anim_length : float = 0
var _curr_anim_pos : float = 0
var _action_time : float = 0


func _on_grid_ability_controller_initialize():
	hitbox = BLOODIED_KATANA_HITBOX.instantiate() as HitBox
	for template in effect_templates:
		effects.append(template.build_effect(controller_context))
		pass
	
	area = area_template.build_area()
	area.set_area_enter_callback(_area_callback)
	print("BUILT AREA FROM TEMPLATE")
	get_tree().root.add_child(hitbox)
	hitbox.effects = effects
	hitbox.collision_mask = collision_mask_layer
	hitbox.global_position = caster.global_position
	#hitbox.anim_player.animation_finished.connect(_on_hitbox_anim_finished)
	pass

func _on_hitbox_anim_finished(anim_name : StringName):
	if anim_name == "bloody_strike":
		hitbox.query_hitbox()
	pass

func _process(delta: float) -> void:
	if !active:
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
			hitbox.look_at(_curr_target.global_position)
		
		hitbox.anim_player.play("bloody_strike")
		_curr_anim_length = hitbox.anim_player.current_animation_length
		_action_time = _curr_anim_length * 0.3
		
		_queue_hit = true
	
	if hitbox.anim_player.is_playing() and _queue_hit:
		_curr_anim_pos = hitbox.anim_player.current_animation_position
		print("ANIM POS: " + str(_curr_anim_pos))
		if _curr_anim_pos >= _action_time:
			hitbox.query_hitbox()
			_queue_hit = false
			pass
		pass
	
	#hitbox.rotation = lerp(hitbox.rotation, 0.0, delta * 20)
	AreaServer.set_area_position(area, caster.global_position)

func _physics_process(delta: float) -> void:
	if !active:
		return

	
	hitbox.global_position = lerp(hitbox.global_position, caster.global_position - ((caster.global_position - hitbox.global_position).normalized() * _dist_threshold), delta * _follow_speed)
	#hitbox.global_position = caster.global_position
	
	_curr_dist_sqrd = hitbox.global_position.distance_squared_to(caster.global_position)
	
	#print("DISTANCE SQRD: " + str(_curr_dist_sqrd) + " DISTANCE THRESHOLD: " + str(_dist_threshold**2))
	
	#print(str(targets))
	
	
	
		#_relative_x = (_curr_target.global_position - hitbox.global_position)
		#_target_angle = rads_to_deg(_relative_x.angle())
		#
		#if _target_angle > 90 or _target_angle < -90:
			#hitbox.scale.x = -1
			#pass
		#else:
			#hitbox.scale.x = 1
		#pass
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
		targets.sort_custom(
			func(a, b):
				var dist_a : float = EntityServer.active_entities[a].global_position.distance_squared_to(hitbox.global_position)
				var dist_b : float = EntityServer.active_entities[b].global_position.distance_squared_to(hitbox.global_position)
				return dist_a < dist_b
		)
		pass
	else:
		if targets.has(area_rid):
			targets.erase(area_rid)
			targets.sort_custom(
				func(a, b):
					var dist_a : float = EntityServer.active_entities[a].global_position.distance_squared_to(hitbox.global_position)
					var dist_b : float = EntityServer.active_entities[b].global_position.distance_squared_to(hitbox.global_position)
					return dist_a < dist_b
			)
	pass

func _exit_tree() -> void:
	hitbox.queue_free()
	area.free_area()
	pass


func rads_to_deg(rad : float) -> float:
	return rad * (180 / PI)
