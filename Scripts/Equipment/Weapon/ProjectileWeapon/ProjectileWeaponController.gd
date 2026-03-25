class_name ProjectileWeaponController extends WeaponController


@export var projectile_animation_player : ProjectileAnimationPlayer
@export var projectile_attack_execute : ProjectileAttackExecute


var projectile_template : ProjectileTemplate

var action_time_ratio : float = 0

var executing : bool = false

var effect_context : Dictionary[StringName, Variant]

var melee_stats : Stats
var queries : Array[RID]

var _input_held : bool = false

func _on_initialized():
	listen_for_input = true
	
	_cooldown = 1 / weapon_stats.get_stat("attack_speed").get_value()
	projectile_attack_execute.projectile_hit.connect(_on_projectile_hit)
	pass

func _on_start():
	if !on_cooldown:
		execute_attack()
		on_cooldown = true
	pass

func execute_attack():
	var attack_context : Dictionary[StringName, Variant] = generate_controller_context()
		
	attack_context.wielder_stats = wielder_stats
	effects = generate_effects(attack_context)
	attack_context.attack_effects = effects
	attack_context.effects_context = effect_context
	attack_context.queries = queries
	attack_context.weapon_stats = weapon_stats
	attack_context.anim_speed = weapon_stats.get_stat("attack_speed").get_value()
	attack_context.action_time_ratio = action_time_ratio
	attack_context.projectile_template = projectile_template
	attack_context.controller = self
	
	
	projectile_attack_execute.execute(attack_context)
	#var projectile : Projectile = projectile_template.build_projectile()
	#projectile.projectile_hit.connect(_on_projectile_hit)
	#projectile.direction = (get_global_mouse_position() - global_position).normalized()
	#projectile.angle = projectile.direction.angle()
	#projectile.texture_angle = projectile.direction.angle()
	#SpawnProjectile.spawn_projectile(projectile, action_point.global_position)
	end_attack()

func _on_process(delta : float):
	if listen_for_input:
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

func send_effects_to_hit(hit : RID):
	for effect in effects:
		EffectServer.receive_effect(hit, effect, effect_context)
		EventServer.effect_hit.emit(hit, effect, effect_context)
	pass

func generate_effects(context : Dictionary[StringName, Variant]) -> Array[Effect]:
	var generated_effects : Array[Effect]
	for template in effect_templates:
		generated_effects.append(template.build_effect(context))
		pass
	return generated_effects

func _on_projectile_hit(hit : RID):
	send_effects_to_hit(hit)
	EventServer.weapon_hit.emit(hit, effects, effect_context)
	weapon_hit.emit(hit, effect_context)
	pass
