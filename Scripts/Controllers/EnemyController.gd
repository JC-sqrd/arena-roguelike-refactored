class_name EnemyController extends Node2D

@export var enemy_entity : EntityNode
@export var enemy_movement : EnemyMovement
@export var target_distance_threshold : float = 125
@export var attack_controller : EnemyAttackController
@export var area_controller : AreaController
@export var health_bar_renderer : HealthBar
@export var death_listeners : Array[OnDeathEventListener]

var unique_death_listeners : Array[OnDeathEventListener]

@export var _components : Array[Node]

var components : Dictionary[StringName, Variant]

#Optimization
var _update_offset : int
var _update_threshold : int = 10
var _is_on_screen : bool = false
#var _dist_to_screen : float = 0
#var _initial_coll_mask : int 
#var _zero_coll_mask : int = 0
#Spatial Partitioning
var _curr_cell_coords : Vector2i = Vector2i.ZERO
var _new_cell_coords : Vector2i = Vector2i.ZERO
var _cell_update_threshold : int = 5
var _id : int
#Soft Collisions
var _separation_radius : float = 32
var _separation_force : float = 30

var _target : Node2D

var _dir_to_target : Vector2 
var _distance_to_target : float

var active : bool = true

var move_speed_stat : Stat
var velocity : Vector2 = Vector2(0,0)

var overlapped_bodies : Array[RID]
var overlapped_areas : Array[Area2D]


func _ready() -> void:
	
	_id = get_instance_id()
	_update_offset = randi_range(0, 10)
	_curr_cell_coords = _calculate_new_cell_coords()
	
	area_controller.initialize()
	area_controller.set_body_enter_callback(_on_body_entered)
	
	#enemy_entity.initalize(get_rid(), self)
	enemy_entity.initialize(area_controller.area.area_rid)
	enemy_entity.entity.health_manager.health_depleted.connect(_on_health_depleted)
	
	enemy_movement.initialize(enemy_entity.entity, self)
	
	move_speed_stat = enemy_entity.entity.stats.get_stat("move_speed")
	
	attack_controller.initialize(enemy_entity.entity.stats)
	
	health_bar_renderer.initialize(enemy_entity.entity.health_manager, self)
	
	_target = PlayerServer.main_player
	
	for component in _components:
		if component.has_method("get_component_name"):
			components[component.get_component_name()] = component
			if component.has_method("initialize"):
				component.initialize(area_controller.area.area_rid)
				pass
		pass
	
	
	for listener in death_listeners:
		unique_death_listeners.append(listener.duplicate(true))
		pass
	
	for listener in unique_death_listeners:
		listener.initialize(enemy_entity.entity)
		pass
	
	EnemyServer.register_enemy(_id, self)
	enemy_entity.entity.global_position = global_position
	#EnemyServer.update_cell_coords(_curr_cell_coords, self)
	EntityServer.register_entity(enemy_entity.entity.entity_rid, enemy_entity.entity)
	pass


func _on_health_depleted(context : Dictionary[StringName, Variant]):
	velocity = Vector2.ZERO
	area_controller.free_area()
	enemy_entity.entity.died.emit(context)
	EventServer.entity_died.emit(EntityDeathEvent.new(enemy_entity.entity, context))
	active = false
	await get_tree().create_timer(0.5).timeout
	area_controller.active = false 
	EnemyServer.to_free(_id)
	#queue_free()
	pass

func _physics_process(delta: float) -> void:
	
	if !active : 
		return
	
	_is_on_screen = get_viewport_rect().has_point(get_global_transform_with_canvas().origin)
	
	
	if (_is_on_screen):
		_update_threshold = 5
		#monitoring = true
		#collision_mask = _initial_coll_mask
	elif (!_is_on_screen and _distance_to_target > 1200 and EnemyServer.get_active_enemies() > 800):
		_update_threshold = 30
		#monitoring = false
		#collision_mask = _zero_coll_mask
	elif (!_is_on_screen and _distance_to_target > 1500 and EnemyServer.get_active_enemies() > 800):
		_update_threshold = 60
		#monitoring = false
		#collision_mask = _zero_coll_mask
	else:
		_update_threshold = 10
		#monitoring = false
		#collision_mask = _zero_coll_mask
	#
	#update_cell_coords(delta)
	#update_position(delta)
	#
	pass

func update_position(delta : float):
	global_position = enemy_entity.entity.global_position
	
	if !active: 
		return
	
	if !enemy_entity.entity.can_move:
		return
	
	enemy_entity.entity.global_position = enemy_movement.update_position(delta) 
	
	#if !active : 
		#return
	#
	#enemy_entity.entity.global_position += velocity 
	#global_position = enemy_entity.entity.global_position
	#
	#if _distance_to_target <= target_distance_threshold:
		#velocity = Vector2.ZERO
		#pass
		#
	##Update velocity and push vector
	#if (Engine.get_frames_drawn() + _update_offset) % _update_threshold == 0:
		#_dir_to_target = (_target.global_position - global_position).normalized()
		#_distance_to_target = (_target.global_position - global_position).length()
		##velocity = (_dir_to_target + _calculate_soft_collisions()) * move_speed_stat.get_value() * delta
		#velocity = _dir_to_target * move_speed_stat.get_value() * delta
	pass

func update_cell_coords(delta : float):
	if !active : 
		return
	#Update cell coordinates
	if (Engine.get_frames_drawn() + _update_offset) % _cell_update_threshold == 0:
		_new_cell_coords = _calculate_new_cell_coords()
		if _new_cell_coords != _curr_cell_coords:
			EnemyServer.move_to_cell(_curr_cell_coords, _new_cell_coords, self)
			_curr_cell_coords = _new_cell_coords
			pass
		pass
	pass

#func _on_body_entered(body : Node2D):
	#overlapped_bodies.append(body)
	#attack_controller.activate(body.get_rid())
	#pass

func _on_body_entered(status : PhysicsServer2D.AreaBodyStatus, body_rid : RID, instance_id : int, body_shape_idx : int, self_shape_idx : int):
	overlapped_bodies.append(body_rid)
	attack_controller.activate(body_rid)
	pass

func _on_body_exited(body : Node2D):
	if overlapped_bodies.has(body):
		overlapped_bodies.erase(body)
	pass

func _calculate_new_cell_coords() -> Vector2i:
	return Vector2i(floori( global_position.x / EnemyServer.tile_size.x), floori( global_position.y / EnemyServer.tile_size.y))

func _calculate_soft_collisions() -> Vector2:
	var push_vector : Vector2 = Vector2.ZERO
	var curr_cell : Vector2i = get_current_cell_coords()
	
	var neighbors : Array[EnemyController] = EnemyServer.get_nearby_enemies(curr_cell)
	
	for neighbor in neighbors:
		if neighbor == self:
			continue
		
		var dist_sq : float = global_position.distance_squared_to(neighbor.global_position)
		var soft_radius_sq = _separation_radius**2
		
		if dist_sq < soft_radius_sq and dist_sq > 0.01:
			var diff : Vector2 = global_position - neighbor.global_position
			var dist : float = sqrt(dist_sq)
			
			var strength : float = (_separation_radius - dist) / _separation_radius
			push_vector += (diff / dist) * strength * _separation_force
			pass
		pass
	
	return push_vector

func get_current_cell_coords() -> Vector2i:
	return _curr_cell_coords

func get_dist_to_screen() -> float:
	var view_rect : Rect2 = get_viewport_rect()
	var screen_min : Vector2 = view_rect.position
	var screen_max : Vector2 = view_rect.end
	
	var dx : float = max(screen_min.x - global_position.x, 0, global_position.x - screen_max.x)
	var dy : float = max(screen_min.y - global_position.y, 0, global_position.y - screen_max.y)
	
	return dx+dy

func _on_area_entered(status : PhysicsServer2D.AreaBodyStatus, area_rid : RID, instance_aid : int, area_shape_idx : int, self_shape_idx : int):
	
	pass

func _exit_tree() -> void:
	EnemyServer.to_free(_id)
	EntityServer.to_free(enemy_entity.entity.entity_rid)
	EnemyServer.free_from_cell(_curr_cell_coords, self)
