class_name EnemyController extends Area2D

@export var enemy_entity : Entity
@export var target_distance_threshold : float = 125
@export var attack_controller : EnemyAttackController

#Optimization
var _update_offset : int
var _update_threshold : int = 10
var _is_on_screen : bool = false
#Spatial Partitioning
var _curr_cell_coords : Vector2i = Vector2i.ZERO
var _new_cell_coords : Vector2i = Vector2i.ZERO
var _cell_update_threshold : int = 5
#Soft Collisions
var _separation_radius : float = 30
var _separation_force : float = 30


var _target : Node2D

var _dir_to_target : Vector2 
var _distance_to_target : float


var move_speed_stat : Stat
var velocity : Vector2 = Vector2(0,0)

var overlapped_bodies : Array[Node2D]
var overlapped_areas : Array[Area2D]

func _ready() -> void:
	
	_update_offset = randi_range(0, 10)
	_curr_cell_coords = _calculate_new_cell_coords()
	
	EnemyServer.register_enemy(_curr_cell_coords, self)
	
	body_entered.connect(_on_body_entered)
	
	
	enemy_entity.initalize(get_rid())
	enemy_entity.health_manager.health_depleted.connect(_on_health_depleted)
	
	move_speed_stat = enemy_entity.stats.get_stat("move_speed")
	
	attack_controller.initialize(enemy_entity.stats)
	
	_target = PlayerServer.main_player
	pass


func _on_health_depleted():
	queue_free()
	pass

func _physics_process(delta: float) -> void:
	
	_is_on_screen = get_viewport_rect().has_point(get_global_transform_with_canvas().origin)
	if (_is_on_screen):
		_update_threshold = 5
		monitoring = false
	else:
		_update_threshold = 10
		monitoring = true
	
	#Update cell coordinates
	if (Engine.get_frames_drawn() + _update_offset) % _cell_update_threshold == 0:
		_new_cell_coords = _calculate_new_cell_coords()
		if _new_cell_coords != _curr_cell_coords:
			EnemyServer.move_to_cell(_curr_cell_coords, _new_cell_coords, self)
			#EnemyServer.erase_key(_curr_cell_coords)
			_curr_cell_coords = _new_cell_coords
			pass
		pass
	
	#Update velocity and push vector
	if (Engine.get_frames_drawn() + _update_offset) % _update_threshold == 0:
		_dir_to_target = (_target.global_position - global_position).normalized()
		_distance_to_target = (_target.global_position - global_position).length()
		#velocity = (_dir_to_target + _calculate_soft_collisions()) * move_speed_stat.get_value() * delta
		velocity = _dir_to_target * move_speed_stat.get_value() * delta
		
	if _distance_to_target <= target_distance_threshold:
		velocity = Vector2.ZERO
		pass
		
	global_position += velocity
	pass

func _on_body_entered(body : Node2D):
	overlapped_bodies.append(body)
	attack_controller.activate(body.get_rid())
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

func _exit_tree() -> void:
	EnemyServer.free_from_cell(_curr_cell_coords, self)
