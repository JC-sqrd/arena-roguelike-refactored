class_name KinematicBody extends RefCounted

# Physics
var body_rid : RID
var shape_rid : RID

# Properties
var parent_node : Node2D
var global_position : Vector2
var angle : float = 0
var active : bool = true
var _space : RID
var xForm : Transform2D

# For Kinematic bodies, we often store velocity to handle manual movement
var velocity : Vector2 = Vector2.ZERO

func update_position(_delta : float):
	if !active:
		return
	
	if parent_node != null:
		global_position = parent_node.global_position
		angle = parent_node.global_rotation
	
	xForm = Transform2D(angle, global_position)
	# Use body_set_state with TRANSFORM constant for better sync with the solver
	PhysicsServer2D.body_set_state(body_rid, PhysicsServer2D.BODY_STATE_TRANSFORM, xForm)

# Note: Bodies don't have "area_entered" signals in the server. 
# They use DirectBodyState or contact reporting if Rigid.
# For Kinematic swarms, we usually handle logic via the Manager or a Raycast.

func free_body():
	if body_rid.is_valid():
		PhysicsServer2D.free_rid(body_rid)
	if shape_rid.is_valid():
		PhysicsServer2D.free_rid(shape_rid)
