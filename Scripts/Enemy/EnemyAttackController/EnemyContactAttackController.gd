class_name EnemyContactAttackController extends EnemyAttackController

@export var area_controller : AreaController

var overlapped_bodies : Array[RID]


func _on_initialized():
	area_controller.set_body_enter_callback(_on_body_entered)


func _on_body_entered(status : PhysicsServer2D.AreaBodyStatus, body_rid : RID, instance_id : int, body_shape_idx : int, self_shape_idx : int):
	
	if active and status == 0:
		overlapped_bodies.append(body_rid)
		activate(body_rid)
	elif active and status == 1:
		if overlapped_bodies.has(body_rid):
			overlapped_bodies.erase(body_rid)
	pass
