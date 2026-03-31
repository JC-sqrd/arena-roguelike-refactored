class_name FireworkMovement extends ProjectileMovement

@export var curve_speed: float = 300.0
@export var idle_speed : float = 150
@export var homing_speed: float = 600.0
@export var steer_force: float = 400.0
@export var boost_duration: float = 0.6
@export var idle_time : float = 5
@export var homing_area_template : AreaTemplate 

var homing_area : Area

var _idle : float = false
var _idle_time : float = 0

var _time_elapsed: float = 0.0
var _target: Entity = null
var _current_velocity: Vector2 = Vector2.ZERO

func initialize(projectile: Projectile):
	super.initialize(projectile)
	homing_area = homing_area_template.build_area()
	_time_elapsed = 0.0

func _on_projectile_initialized():
	var spread : float = deg_to_rad(10)
	var dir_angle : float = projectile.direction.angle()
	var min_angle : float = dir_angle - spread
	var max_angle : float = dir_angle + spread
	var random_angle : float = randf_range(min_angle, max_angle)
	var launch_vec : Vector2 = projectile.direction.rotated(random_angle)
	#_current_velocity = launch_vec * curve_speed
	pass

func update_movement(delta: float):
	_time_elapsed += delta
	
	if _time_elapsed < boost_duration:
		# PHASE 1: Initial Arc (Classic linear movement with slight drag or curve)
		_current_velocity = _current_velocity.lerp(projectile.direction * curve_speed, delta * 2.0)
	else:
		# PHASE 2: Homing
		if _target == null:
			_target = EntityServer.active_entities.get(_find_nearest_enemy())
			if _target == null:
				_idle = true
			pass
		elif EntityServer.active_entities.has(_target.entity_rid):
			var to_target : Vector2  = _target.global_position - projectile.global_position
			var distance_sqrd : float = to_target.length_squared()
			if distance_sqrd > 100.0: # Only steer if we aren't already "there"
				var desired : Vector2  = to_target.normalized() * homing_speed
				var steer : Vector2  = (desired - _current_velocity)
				steer.limit_length(steer_force)
				_current_velocity += steer * delta
				_idle = false
		else:
			_idle = true
	
	if _idle:
		_idle_time += delta
		_current_velocity = _current_velocity.lerp(projectile.direction * idle_speed, delta * 2.0)
	
	if _idle_time >= idle_time:
		_target = null
		var projectile_rid : RID = projectile.projectile_rid
		var area_rid : RID = homing_area.area_rid
		
		projectile.active = false
		
		homing_area.free_area()
		homing_area = null
		
		ProjectileServer.to_free(projectile_rid)
		AreaServer.to_free(area_rid)
		return
	
	# Apply movement using your existing PhysicsServer logic
	projectile.velocity = _current_velocity * delta
	projectile.global_position += projectile.velocity
	_range_counter += projectile.velocity.length()
	
	homing_area.global_position = projectile.global_position
	# Update Rotation to face moving direction
	projectile.angle = _current_velocity.angle()
	projectile.texture_angle = projectile.angle
	
	var area_xForm : Transform2D = Transform2D(homing_area.angle, homing_area.global_position)
	PhysicsServer2D.area_set_transform(homing_area.area_rid, area_xForm)
	
	var xForm: Transform2D = Transform2D(projectile.angle, projectile.global_position)
	PhysicsServer2D.area_set_transform(projectile.projectile_rid, xForm)
	
	#if _range_counter >= (range):
		

func _find_nearest_enemy() -> RID:
	var space_state : PhysicsDirectSpaceState2D = PhysicsServer2D.space_get_direct_state(homing_area._space)#get_world_2d().direct_space_state	
	
	var results : Array[Dictionary]
	
	var query : PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
	query.shape_rid = homing_area.shape_rid
	query.transform = homing_area.xForm
	query.collision_mask = homing_area.coll_mask
	query.collide_with_areas = true
		
	results = space_state.intersect_shape(query, 500)
	if results.is_empty():
		return RID()
	return results[0].rid
