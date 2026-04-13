extends GridAbilityController

@export var area_template : AreaTemplate
@export var stone_ability : AbilityData
@export var spawn_projectile_action : SpawnProjectileAbilityAction

var ability : ActiveAbility


@export var cooldown : float = 1
var curr_cd : float = 0

var projectilie_count : int = 1
var _bonus_projectile_count : int = 0
var _timer : Timer 

func _on_initialized():
	spawn_projectile_action.initialize(caster, self)
	var projectile_count_stat : Stat = caster.stats.get_stat("projectile_count")
	if projectile_count_stat != null:
		_bonus_projectile_count = int(projectile_count_stat.get_value())
		pass
	_timer = Timer.new()
	add_child(_timer)
	pass

func start_ability():
	throw_stone()
	pass

func throw_stone():
	var total_projectiles : int = projectilie_count + _bonus_projectile_count
	var degree_of_separation : float = 10
	var angle : float = 0
	for i in (total_projectiles):
		var dir : Vector2 = (ProjectileServer.get_global_mouse_position() - caster.action_point).normalized()
		angle = dir.angle()
		dir = Vector2.RIGHT.rotated(angle + deg_to_rad(i * degree_of_separation))
		spawn_projectile_action.look_at_mouse = false
		spawn_projectile_action.shoot_at_mosue = false
		spawn_projectile_action.projectile_angle = angle
		spawn_projectile_action.projectile_direction = dir
		spawn_projectile_action.do(caster, controller_context)
		#_timer.start(0.05)
		#await _timer.timeout
	pass

func _process(delta: float) -> void:
	if !active:
		return 
	
	curr_cd += delta
	if curr_cd >= cooldown:
		curr_cd = 0
		start_ability()
	pass
