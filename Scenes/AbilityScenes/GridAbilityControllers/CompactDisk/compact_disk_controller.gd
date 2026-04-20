extends GridAbilityController

const COMPACT_DISK_HITBOX = preload("uid://8j11sug2jlbu")

@export var effect_templates : Array[EffectTemplate]
@export var orbit_distance : float = 64

var cd_hitbox : HitBox
var duration : float = 3
var cooldown : float = 5
var cooling_down : bool = false

var orbiting : bool = false

var _curr_dur : float = 0
var _curr_cd : float = 0
var orbit_center : Vector2
var orbit_offset : Vector2
var orbit_angle : float = 0

var start : bool = false

var active_hitboxes : Array[HitBox]

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
			for hitbox in active_hitboxes:
				hitbox.queue_free()
			active_hitboxes.clear()
		
		_curr_dur += delta
		
		orbit_angle = fposmod(orbit_angle, (2 * PI))
		orbit_angle += (5 * delta)
		
		for i in range(active_hitboxes.size()):
			var hitbox : HitBox = active_hitboxes[i]
			
			var spacing_offset : float = i * (2 * PI / active_hitboxes.size())
			var i_angle : float = orbit_angle + spacing_offset
			
			orbit_offset = (Vector2.UP * 16) + caster.global_position + (Vector2.from_angle(i_angle).normalized() * orbit_distance) 
				
			var hits : Array[RID] = hitbox.query_hits(true, 1)
			var context : Dictionary[StringName, Variant] = generate_controller_context()
			for hit in hits:
				for template in effect_templates:
					EffectServer.receive_effect(hit, template.build_effect(context), context)
			
			hitbox.global_position = orbit_offset
		pass
	pass

func start_ability():
	for i in range(level):
		cd_hitbox = COMPACT_DISK_HITBOX.instantiate()
		cd_hitbox.context = controller_context
		active_hitboxes.append(cd_hitbox)
		#cd_hitbox.effects = effects
		get_tree().root.add_child(cd_hitbox)
	orbiting = true
	pass

func _exit_tree() -> void:
	for hitbox in active_hitboxes:
		hitbox.queue_free()
	active_hitboxes.clear()
	if cd_hitbox != null:
		cd_hitbox.queue_free()
	pass
