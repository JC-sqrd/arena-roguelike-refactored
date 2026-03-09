class_name EnemySpawner extends Node

@export var interactable : Interactable
@export var cooldown : float = 60

var can_spawn : bool = true

const SMALL_ENEMY = preload("uid://b00aqxyistgiy")

var _cooldown_counter : float = 0


func _ready() -> void:
	interactable.interacted.connect(_on_interacted)
	pass

func _on_interacted():
	if can_spawn:
		can_spawn = false
		for i in range(randi_range(200, 400)):
			if EnemyServer.active_enemies.size() >= 1500:
				break
			spawn_enemy()
			pass
	get_tree().create_timer(cooldown).timeout.connect(_on_cooldown_end)
	#queue_free()dd
	pass

func _on_cooldown_end():
	can_spawn = true
	pass

func spawn_enemy():
	
	var viewport_size : = get_viewport().get_visible_rect().size
	var camera_pos : = get_viewport().get_camera_2d().global_position
	
	var spawn_radius : float = (viewport_size / 2).length() + 1200
	var random_angle : float = randf() * TAU
	var spawn_offset : Vector2 = Vector2.from_angle(random_angle) * spawn_radius

	#var rand_pos : Vector2 = Vector2(randf_range(0, max_x), randf_range(0, max_y))
	var enemy : EnemyController = SMALL_ENEMY.instantiate() as EnemyController
	enemy.global_position = camera_pos + spawn_offset#rand_pos
	get_tree().root.add_child(enemy)
	pass
