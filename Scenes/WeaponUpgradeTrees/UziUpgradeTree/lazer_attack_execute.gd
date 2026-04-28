extends ProjectileAttackExecute

@export var off_timer : Timer
@export var rate_timer : Timer
@export var shape : RectangleShape2D
@export_flags_2d_physics var coll_mask : int
var laser_on : bool = false
const UZI_LAZER = preload("uid://785xe88m6cnm")
const UZI_LASER_RAYCAST = preload("uid://d21c7e041j08w")

var lazer : LaserRayCast

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
	if lazer.is_colliding():
		var hit : RID = lazer.get_collider_rid()
		projectile_hit.emit(hit)
	rate_timer.start(0.1)
	pass

func execute():
	if !active:
		generate_execute_context()
		lazer = UZI_LASER_RAYCAST.instantiate() as LaserRayCast
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
