class_name MeleeController extends WeaponController


@export var melee_hitbox : Area2D
@export var melee_animation_player : MeleeAnimationPlayer

var attack_strategy : AttackStrategy
var attack_execute : MeleeAttackExecute

var executing : bool = false

var effect_context : Dictionary[StringName, Variant]

var melee_stats : Stats
var queries : Array[RID]

var _input_held : bool = false

func initialize():
	attack_execute = attack_strategy.build_execute()
	add_child(attack_execute)
	
	listen_for_input = true
	
	attack_execute.set_melee_anim_player(melee_animation_player)
	attack_execute.set_melee_hitbox(melee_hitbox)
	attack_execute.finished_executing.connect(_on_attack_finished_executing)
	pass

func start_attack():
	execute_attack()
	attack_start.emit()
	pass

func execute_attack():
	if !attack_execute.active:
		var attack_context : MeleeAttackExecuteContext = MeleeAttackExecuteContext.new()
	
		attack_context.wielder_stats = wielder_stats
		attack_context.attack_effects = effects
		attack_context.effects_context = effect_context
		attack_context.queries = queries
	
		attack_execute.execute(attack_context)
		attack_executed.emit()
	pass

func end_attack():
	attack_end.emit()
	pass

func _on_attack_finished_executing():
	end_attack()
	pass

func _process(delta: float) -> void:
	if listen_for_input:
		look_at(get_global_mouse_position())

func _unhandled_input(event: InputEvent) -> void:
	if !listen_for_input:
		return
		
	if event is InputEventMouseButton and Input.is_action_pressed("attack"):
		_input_held = true
		pass
	
	if event is InputEventMouseButton and Input.is_action_just_released("attack"):
		_input_held = false
	
	if _input_held:
		start_attack()
	pass
