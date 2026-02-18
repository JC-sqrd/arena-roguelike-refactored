class_name MeleeWeaponNode extends Node2D


@export var melee_hitbox : Area2D

var attack_strategy : AttackStrategy
var attack_execute : MeleeAttackExecute

var listen_for_input : bool = false
var executing : bool = false

var effects : Array[Effect]
var wielder_stats : Stats
var weapon_stats : Stats
var effect_context : Dictionary[StringName, Variant]

var queries : Array[RID]

func _ready() -> void:
	
	pass

func initialize():
	attack_execute = attack_strategy.build_execute()
	add_child(attack_execute)
	listen_for_input = true
	melee_hitbox.area_entered.connect(_on_area_entered)
	melee_hitbox.area_exited.connect(_on_area_exited)
	pass

func start_attack():
	print("START MELEE ATTACK!")
	
	var attack_context : MeleeAttackExecuteContext = MeleeAttackExecuteContext.new()
	
	attack_context.wielder_stats = wielder_stats
	attack_context.attack_effects = effects
	attack_context.melee_hitbox = melee_hitbox
	attack_context.effects_context = effect_context
	attack_context.queries = queries
	
	attack_execute.execute(attack_context)
	
	pass

func _unhandled_input(event: InputEvent) -> void:
	if !listen_for_input:
		return
		
	if event is InputEventMouseButton and Input.is_action_just_pressed("attack"):
		#print("START ATTACK INPUT!")
		start_attack()
		pass
	pass

func _on_area_entered(area : Area2D):
	print("AREA ENTERED MELEE HITBOX")
	var area_rid : RID = area.get_rid()
	if !queries.has(area_rid):
		queries.append(area_rid)
		pass
	pass

func _on_area_exited(area : Area2D):
	print("AREA EXITED MELEE HITBOX")
	var area_rid : RID = area.get_rid()
	if queries.has(area_rid):
		queries.erase(area_rid)
		pass
	pass
