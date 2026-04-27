extends ProjectileAttackExecute

@export var off_timer : Timer
@export var rate_timer : Timer
@export var shape : RectangleShape2D
@export_flags_2d_physics var coll_mask : int
var laser_on : bool = false
const UZI_LAZER = preload("uid://785xe88m6cnm")
var lazer : Line2D

func initialize(controller : WeaponController):
	super(controller)
	shape = shape.duplicate()
	off_timer.timeout.connect(_on_off_timeout)
	rate_timer.timeout.connect(_on_rate_timeout)
	pass

func _physics_process(delta: float) -> void:
	if !laser_on:
		return
	
	if !rate_timer.is_stopped():
		print("LAZER IN BETWEEN: ", rate_timer.time_left)
		return
	
	print("LAZER QUERYING")
	var space_state = lazer.get_world_2d().direct_space_state
	var mouse_pos : Vector2 = lazer.get_global_mouse_position()
	var dir : Vector2 = (mouse_pos - controller.action_point.global_position).normalized()
	var target_pos : Vector2 = controller.action_point.global_position + (dir * 128)
	
	#var query = PhysicsRayQueryParameters2D.create(controller.action_point.global_position, target_pos)
	var query : PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
	var offset : Vector2 = Vector2((shape.size.x / 2), 0)
	var xForm : Transform2D = Transform2D(lazer.rotation, lazer.global_position)
	query.shape = shape
	query.transform = xForm.translated(offset) 
	
	
	query.collision_mask = coll_mask
	query.collide_with_areas = true
	
	var results = space_state.intersect_shape(query)
	for hit in results:
		projectile_hit.emit(hit.rid)
	#if result:
		#projectile_hit.emit(result.rid)
	
	rate_timer.start(0.1)
	pass

func execute():
	if !active:
		generate_execute_context()
		lazer = UZI_LAZER.instantiate() as Line2D
		controller.action_point.add_child(lazer)
	
	laser_on = true
	off_timer.start(0.2)
	active = true
	pass

func _on_off_timeout():
	laser_on = false
	active = false
	if lazer != null:
		lazer.queue_free()
	pass

func _on_rate_timeout():
	
	pass

func finish_execute():
	pass

func _on_projectile_hit(hit : RID):
	projectile_hit.emit(hit)
	pass
