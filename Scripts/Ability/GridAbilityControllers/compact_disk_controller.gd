extends GridAbilityController

const COMPACT_DISK_HITBOX = preload("uid://8j11sug2jlbu")

@export var effect_templates : Array[EffectTemplate]
@export var orbit_distance : float = 64

var cd_hitbox : HitBox
var duration : float = 3
var cooldown : float = 6
var cooling_down : bool = false

var orbiting : bool = false

var _curr_dur : float = 0
var _curr_cd : float = 0
var orbit_center : Vector2
var orbit_offset : Vector2
var orbit_angle : float = 0

var start : bool = false

func _on_initialized():
	#cd_hitbox = COMPACT_DISK_HITBOX.instantiate()
	#get_tree().root.add_child(cd_hitbox)
	for template in effect_templates:
		effects.append(template.build_effect(controller_context))
		pass
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
			cd_hitbox.queue_free()
			_curr_dur = 0
			cooling_down = true
			orbiting = false
		
		_curr_dur += delta
		
		orbit_angle += (5 * delta)
		
		orbit_angle = fposmod(orbit_angle, (2 * PI))
		
		orbit_offset = (Vector2.UP * 32) + caster.global_position + (Vector2.from_angle(orbit_angle).normalized() * orbit_distance) 
		
		cd_hitbox.query_hitbox(true)
		
		cd_hitbox.global_position = orbit_offset
		pass
	pass

func start_ability():
	cd_hitbox = COMPACT_DISK_HITBOX.instantiate()
	cd_hitbox.context = controller_context
	cd_hitbox.effects = effects
	get_tree().root.add_child(cd_hitbox)
	orbiting = true
	pass

func _exit_tree() -> void:
	if cd_hitbox != null:
		cd_hitbox.queue_free()
	pass
