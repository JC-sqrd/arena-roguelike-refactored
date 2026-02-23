class_name EnemyController extends Area2D

@export var enemy_entity : Entity
@export var target_distance_threshold : float = 125
@export var attack_controller : EnemyAttackController
var _target : Node2D

var _dir_to_target : Vector2 
var _distance_to_target : float
var _was_near_target : bool = false

var move_speed_stat : Stat
var velocity : Vector2

var overlapped_bodies : Array[Node2D]
var overlapped_areas : Array[Area2D]

func _ready() -> void:
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
	_dir_to_target = (_target.global_position - global_position).normalized()
	_distance_to_target = (_target.global_position - global_position).length()
	velocity = _dir_to_target * move_speed_stat.get_value() * delta
	
	#print("ENEMY DISTANCE TO TARGET: " + str(_distance_to_target))
	
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
