class_name AreaTemplate extends Resource


@export var monitorable : bool = false
@export var area_shape : AreaShape

@export_flags_2d_physics var area_coll_layer : int = 0
@export_flags_2d_physics var area_coll_mask : int = 0


func build_area() -> Area:
	var area : Area = Area.new()
	
	#Physics
	
	area.area_rid = PhysicsServer2D.area_create()
	
	area._space = AreaServer.get_world_2d().space
	
	area.shape_rid = area_shape.set_area_shape(area.area_rid)
	
	var xForm : Transform2D = Transform2D(0, Vector2(0,0))
	
	PhysicsServer2D.area_set_transform(area.area_rid, xForm)
	
	PhysicsServer2D.area_set_space(area.area_rid, area._space)
	
	PhysicsServer2D.area_set_monitorable(area.area_rid, monitorable)
	
	PhysicsServer2D.area_set_area_monitor_callback(area.area_rid, area._on_area_entered)
	
	PhysicsServer2D.area_set_monitor_callback(area.area_rid, area._on_body_entered)
	
	PhysicsServer2D.area_set_collision_layer(area.area_rid, area_coll_layer)
	
	PhysicsServer2D.area_set_collision_mask(area.area_rid, area_coll_mask)
	
	area.coll_layer = area_coll_layer
	
	area.coll_mask = area_coll_mask
	return area
