class_name MeleeWeaponController extends WeaponController


@export var melee_hitbox : HitBox
@export var melee_animation_player : MeleeAnimationPlayer


var action_time_ratio : float = 0

@export var attack_execute : MeleeAttackExecute
var attack_strategy : AttackStrategy

var executing : bool = false

var effect_context : Dictionary[StringName, Variant]

var queries : Array[RID]

var _input_held : bool = false

signal weapon_hits(hits : Array[RID], weapon_effects : Array[Effect], context : Dictionary[StringName, Variant])

func _on_initialized():
	
	attack_execute.initialize(self)
	attack_execute.hit.connect(_on_hit)
	attack_execute.to_hit.connect(_on_to_hit)
	
	
	listen_for_input = true
	
	attack_execute.set_melee_anim_player(melee_animation_player)
	attack_execute.set_melee_hitbox(melee_hitbox)
	attack_execute.finished_executing.connect(_on_attack_finished_executing)
	
	
	
	_cooldown = 1 / (weapon_stats.get_stat("attack_speed").get_value() * wielder_stats.get_stat("attack_speed_mult").get_value())
	pass

func _on_start():
	execute_attack()
	on_cooldown = true
	pass


func execute_attack():
	if !attack_execute.active and !on_cooldown:
		#melee_hitbox.effects = effects
		#melee_hitbox.context = effect_context
		
		attack_execute.execute()
		end_attack()

func generate_effects(context : Dictionary[StringName, Variant]) -> Array[Effect]:
	var generated_effects : Array[Effect]
	for template in effect_templates:
		generated_effects.append(template.build_effect(context))
		pass
	return generated_effects

func _on_attack_finished_executing():
	end_attack()
	pass

func _on_process(delta):
	if listen_for_input:
		look_at(get_global_mouse_position())
	
	if on_cooldown:
		_curr_cooldown += delta
	
	if _curr_cooldown >= _cooldown:
		on_cooldown = false
		_curr_cooldown = 0

func _on_to_hit(hit : RID, weapon_effects : Array[Effect], context : Dictionary[StringName, Variant]):
	weapon_to_hit.emit(hit, weapon_effects, context)
	pass

func _on_hit(hit : RID, weapon_effects : Array[Effect], context : Dictionary[StringName, Variant]):
	EventServer.weapon_hit.emit(hit, weapon_effects, controller_context)
	weapon_hit.emit(hit, weapon_effects, context)
	send_effects_to_hit(hit, weapon_effects)
	effects.clear()
	pass

func _on_hits(hits : Array[RID], weapon_effects : Array[Effect], context : Dictionary[StringName, Variant]):
	weapon_hits.emit(hits, weapon_effects, context)
	pass

func send_effects_to_hit(hit : RID, effects : Array[Effect]):
	for effect in effects:
		EffectServer.receive_effect(hit, effect, controller_context)
	pass

func set_attack_execute(atk_exec : AttackExecute):
	attack_execute = atk_exec
	attack_execute.initialize(self)
	pass

func get_attack_execute() -> AttackExecute:
	return attack_execute
