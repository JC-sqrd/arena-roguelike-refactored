class_name ProjectileWeaponController extends WeaponController


@export var projectile_animation_player : ProjectileAnimationPlayer
@export var projectile_attack_execute : ProjectileAttackExecute


var projectile_template : ProjectileTemplate

var action_time_ratio : float = 0

var executing : bool = false

var queries : Array[RID]

var _input_held : bool = false

func _on_initialized():
	_cooldown = 1 / (weapon_stats.get_stat("attack_speed").get_value() * wielder_stats.get_stat("attack_speed_mult").get_value())
	set_attack_execute(projectile_attack_execute)
	pass

func _on_start():
	execute_attack()
	pass

func execute_attack():
	if projectile_attack_execute.executing:
		return
	
	controller_context = generate_controller_context()
	var attack_effects : Array[Effect] = generate_effects(controller_context)
	
	controller_context.wielder_stats = wielder_stats
	effects.clear()
	effects = attack_effects
	controller_context.effects_context = controller_context
	controller_context.queries = queries
	controller_context.weapon_stats = weapon_stats
	controller_context.anim_speed = weapon_stats.get_stat("attack_speed").get_value()
	controller_context.action_time_ratio = action_time_ratio
	controller_context.projectile_template = projectile_template
	controller_context.controller = self
	
	projectile_attack_execute.execute(controller_context)
	end_attack()

func _on_process(delta : float):
	look_at(get_global_mouse_position())
	
	if on_cooldown:
		_curr_cooldown += delta
	
	if _curr_cooldown >= _cooldown:
		on_cooldown = false
		_curr_cooldown = 0
	pass

func _unhandled_input(event: InputEvent) -> void:
	if !listen_for_input:
		return
	pass

func send_effects_to_hit(hit : RID, effects : Array[Effect], context : Dictionary[StringName, Variant]):
	for effect in effects:
		EffectServer.receive_effect(hit, effect, context)
		EventServer.effect_hit.emit(hit, effect, context)
	pass

func generate_effects(context : Dictionary[StringName, Variant]) -> Array[Effect]:
	var generated_effects : Array[Effect]
	for template in effect_templates:
		generated_effects.append(template.build_effect(context))
		pass
	return generated_effects

func _on_projectile_hit(hit : RID):
	var projectile_effects : Array[Effect] = generate_effects(controller_context)
	var context : Dictionary[StringName, Variant] = generate_controller_context()
	print("PROECTILE CONTEXT: ", str(context))
	EventServer.weapon_hit.emit(hit, projectile_effects, context)
	weapon_hit.emit(hit, context)
	send_effects_to_hit(hit, projectile_effects, context)
	effects.clear()
	pass

func set_attack_execute(atk_exec : AttackExecute):
	projectile_attack_execute = atk_exec
	projectile_attack_execute.projectile_hit.connect(_on_projectile_hit)
	pass

func get_attack_execute() -> ProjectileAttackExecute:
	return projectile_attack_execute
