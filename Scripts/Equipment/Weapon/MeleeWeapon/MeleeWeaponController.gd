class_name MeleeWeaponController extends WeaponController


@export var melee_hitbox : HitBox
@export var melee_animation_player : MeleeAnimationPlayer


var action_time_ratio : float = 0

@export var attack_execute : MeleeAttackExecute
var attack_strategy : AttackStrategy

var executing : bool = false

var effect_context : Dictionary[StringName, Variant]

var melee_stats : Stats
var queries : Array[RID]

var _input_held : bool = false

func _on_initialized():
	
	attack_execute.hit.connect(_on_hit)
	
	listen_for_input = true
	
	attack_execute.set_melee_anim_player(melee_animation_player)
	attack_execute.set_melee_hitbox(melee_hitbox)
	attack_execute.finished_executing.connect(_on_attack_finished_executing)
	
	_cooldown = 1 / weapon_stats.get_stat("attack_speed").get_value()
	pass

func start_attack():
	if !on_cooldown:
		execute_attack()
		attack_start.emit()
		on_cooldown = true
	pass

func execute_attack():
	if !attack_execute.active:
		var attack_context : Dictionary[StringName, Variant] = generate_controller_context()
	
		attack_context.wielder_stats = wielder_stats
		attack_context.attack_effects = generate_effects()
		attack_context.effects_context = effect_context
		attack_context.queries = queries
		attack_context.weapon_stats = weapon_stats
		attack_context.anim_speed = weapon_stats.get_stat("attack_speed").get_value()
		attack_context.action_time_ratio = action_time_ratio
		
		melee_hitbox.effects = effects
		melee_hitbox.context = effect_context
		
		attack_execute.execute(attack_context)
		attack_executed.emit()
	pass

func end_attack():
	attack_end.emit()
	pass

func generate_effects() -> Array[Effect]:
	return effects.duplicate(true)

func _on_attack_finished_executing():
	end_attack()
	pass

func _process(delta: float) -> void:
	if listen_for_input:
		look_at(get_global_mouse_position())
	
	if on_cooldown:
		_curr_cooldown += delta
	
	if _curr_cooldown >= _cooldown:
		on_cooldown = false
		_curr_cooldown = 0


func _on_hit(hits : Array[RID]):
	weapon_hit.emit(hits)
	EventServer.weapon_hit.emit(hits, effect_context)
	pass
