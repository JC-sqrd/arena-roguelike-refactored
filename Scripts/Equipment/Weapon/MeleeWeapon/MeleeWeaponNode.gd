class_name MeleeWeaponNode extends Node2D


@export var melee_hitbox : Area2D
@export var melee_animation_player : MeleeAnimationPlayer

var attack_strategy : AttackStrategy
var attack_execute : MeleeAttackExecute

var listen_for_input : bool = false
var executing : bool = false

var effects : Array[Effect]
var wielder_stats : Stats
var weapon_stats : Stats
var effect_context : Dictionary[StringName, Variant]

var queries : Array[RID]

var _input_held : bool = false

func initialize():
	attack_execute = attack_strategy.build_execute()
	add_child(attack_execute)
	
	listen_for_input = true
	melee_hitbox.area_entered.connect(_on_area_entered)
	melee_hitbox.area_exited.connect(_on_area_exited)
	
	attack_execute.set_melee_anim_player(melee_animation_player)
	attack_execute.set_melee_hitbox(melee_hitbox)
	pass

func start_attack():
	
	if !attack_execute.active:
		var attack_context : MeleeAttackExecuteContext = MeleeAttackExecuteContext.new()
	
		attack_context.wielder_stats = wielder_stats
		attack_context.attack_effects = effects
		attack_context.effects_context = effect_context
		attack_context.queries = queries
	
		attack_execute.execute(attack_context)
	pass

#func _process(delta: float) -> void:
	#if listen_for_input:
		#look_at(get_global_mouse_position())

func _unhandled_input(event: InputEvent) -> void:
	if !listen_for_input:
		return
		
	if event is InputEventMouseButton and Input.is_action_pressed("attack"):
		_input_held = true
		pass
	
	if event is InputEventMouseButton and Input.is_action_just_released("attack"):
		_input_held = false
	
	if _input_held:
		print("START ATTACK INPUT!")
		start_attack()
	
	pass

func _on_area_entered(area : Area2D):
	var area_rid : RID = area.get_rid()
	if !queries.has(area_rid):
		queries.append(area_rid)
		pass
	pass

func _on_area_exited(area : Area2D):
	var area_rid : RID = area.get_rid()
	if queries.has(area_rid):
		queries.erase(area_rid)
		pass
	pass
