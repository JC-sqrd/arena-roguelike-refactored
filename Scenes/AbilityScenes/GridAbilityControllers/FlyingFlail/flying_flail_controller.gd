extends GridAbilityController

const FLYING_FLAIL_HITBOX = preload("uid://k7y78mwvl3gb")

@export var effect_templates : Array[EffectTemplate]
@export var distance_curve : Curve
@export var orbit_distance : float = 64

const FLYING_FLAIL_CHAIN = preload("uid://c5qyfdmtd1hef")

const CHAIN_TEXTURE = preload("uid://cr4eh2yaxadki")

var hitbox : HitBox
var duration : float = 8
var cooldown : float = 6
var cooling_down : bool = false

var orbiting : bool = false

var _curr_dur : float = 0
var _curr_cd : float = 0
var orbit_center : Vector2
var orbit_offset : Vector2
var orbit_angle : float = 0
var _chain : Line2D

var _orbit_speed : float = 10

var start : bool = false

func _on_initialized():
	#hitbox = COMPACT_DISK_HITBOX.instantiate()
	#get_tree().root.add_child(hitbox)
	for template in effect_templates:
		effects.append(template.build_effect(controller_context))
		pass
	duration += 0.5 * level
	cooling_down = true
	pass

func _process(delta: float) -> void:
	
	if !active:
		return
	
	if cooling_down:
		_curr_cd += delta
	
	if _curr_cd >= cooldown:
		_curr_cd = 0
		cooling_down = false
		start = true
		pass
	
	if start:
		start_ability()
		start = false
		pass
	
	if orbiting:
		
		if _curr_dur >= duration:
			hitbox.queue_free()
			_chain.queue_free()
			_curr_dur = 0
			cooling_down = true
			orbiting = false
		
		_curr_dur += delta
		
		orbit_angle += (_orbit_speed * delta)
		
		orbit_angle = fposmod(orbit_angle, (2 * PI))
		
		orbit_offset = (Vector2.UP * 16) + caster.global_position + (Vector2.from_angle(orbit_angle).normalized() * ((orbit_distance + (level * 10)) * (distance_curve.sample(_curr_dur / duration)))) 
		
		var hits : Array[RID] = hitbox.query_hits(true)
		var context : Dictionary[StringName, Variant] = generate_controller_context()
		for hit in hits:
			for template in effect_templates:
				EffectServer.receive_effect(hit, template.build_effect(context), context)
		
		_chain.clear_points()
		hitbox.global_position = orbit_offset
		_chain.add_point(caster.action_point)
		_chain.add_point(hitbox.global_position)
		pass
	pass

func start_ability():
	hitbox = FLYING_FLAIL_HITBOX.instantiate()
	hitbox.context = controller_context
	_chain = FLYING_FLAIL_CHAIN.instantiate()
	get_tree().root.add_child(_chain)
	get_tree().root.add_child(hitbox)
	orbiting = true
	pass


func _exit_tree() -> void:
	if hitbox != null:
		hitbox.queue_free()
	if _chain != null:
		_chain.queue_free()
	pass
