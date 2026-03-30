#Dash Punch Ability Controller
extends ActiveAbilityController

@export var max_dash_distance : float = 128
@export var dash_speed : float = 600
@export var acceleration : float = 1000

@export var punch_effect_temp : EffectTemplate

var punch_effect : Effect

const GROUND_SLAM_HITBOX = preload("uid://hkn4jr4vsdqg")

var dashing : bool = false
var dash_force : Vector2
var max_distance_squared : float

var _displacement : Vector2 
var _curr_speed : float = 0 
var _dash_direction : Vector2
var _distance_traveled_squared : float = 0
var _dash_time : float = 0 
var timer : float = 0 
var input_dir : Vector2

func _on_initialized():
	
	pass


func _on_start():
	ability_to_execute.emit()
	if dashing:
		return
	caster.can_move = false
	caster.can_cast = false
	dashing = true
	input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_dir.length() == 0:
		_dash_direction = Vector2.RIGHT
	else:
		_dash_direction = input_dir.normalized()#(ArenaServer.active_arena.get_global_mouse_position() - caster.global_position).normalized()
	_curr_speed = dash_speed
	max_distance_squared = max_dash_distance ** 2
	_dash_time = max_dash_distance / dash_speed
	pass

func _physics_process(delta: float) -> void:
	if !dashing:
		return
	
	_curr_speed += acceleration * delta
	dash_force = _dash_direction * dash_speed 
	caster.velocity = dash_force
	
	timer += delta
	
	if timer >= _dash_time:
		ability_executed.emit()
		print("DASH PUNCH END")
		end()
		stop_dash()
		var hitbox : DelayHitbox = GROUND_SLAM_HITBOX.instantiate() as DelayHitbox
		controller_context = generate_controller_context()
		punch_effect = null
		punch_effect = punch_effect_temp.build_effect(controller_context)
		hitbox.hits_queried.connect(_on_hit_queried)
		ArenaServer.active_arena.add_child(hitbox)
		hitbox.global_position = caster.global_position
	pass

func stop_dash():
	timer = 0
	_curr_speed = 0
	_distance_traveled_squared = 0
	caster.can_cast = true
	caster.can_move = true
	dashing = false
	pass

func _on_hit_queried(hits : Array[RID]):
	for hit in hits:
		EffectServer.receive_effect(hit, punch_effect_temp.build_effect(controller_context), controller_context)
		pass
	pass
