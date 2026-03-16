class_name KinematicBodyTemplate extends Resource

@export var body_shape : AreaShape # Reusing your existing shape wrapper
@export_flags_2d_physics var collision_layer : int = 1
@export_flags_2d_physics var collision_mask : int = 1
@export var collision_priority : float = 1.0

func build_body() -> KinematicBody:
	var body : KinematicBody = KinematicBody.new()
	
	# 1. Create the Body
	body.body_rid = PhysicsServer2D.body_create()
	
	# 2. Set to Kinematic (it won't fall due to gravity, moves via script)
	PhysicsServer2D.body_set_mode(body.body_rid, PhysicsServer2D.BODY_MODE_KINEMATIC)
	
	# 3. Setup Space and Shape
	body._space = AreaServer.get_world_2d().space
	PhysicsServer2D.body_set_space(body.body_rid, body._space)
	
	# Assuming your AreaShape class returns an RID and attaches it
	body.shape_rid = body_shape.set_area_shape(body.body_rid) 
	
	# 4. Collision Settings
	PhysicsServer2D.body_set_collision_layer(body.body_rid, collision_layer)
	PhysicsServer2D.body_set_collision_mask(body.body_rid, collision_mask)
	
	# Initial Transform
	body.update_position(0)
	
	return body
