class_name ProjectileTemplate extends Resource


@export var speed : float = 0
@export var projectile_shape : ProjectileShape
@export var pierce : int = 0
@export var range : float = 256
@export var monitorable : bool = false

@export var projectile_texture : Texture2D
@export var z_index : int = 15

@export_flags_2d_physics var projectile_coll_layer : int = 0
@export_flags_2d_physics var projectile_coll_mask : int = 0

func build_projectile() -> Projectile:
	var projectile : Projectile = Projectile.new()
	
	projectile.range = range
	
	projectile.pierce = pierce
	
	projectile.speed = speed
	
	projectile.movement = ProjectileMovement.new()
	
	projectile.movement.projectile = projectile
	
	#Physics
	
	projectile.projectile_rid = PhysicsServer2D.area_create()
	
	projectile._space = ProjectileServer.get_world_2d().space
	
	projectile_shape.set_projectile_shape(projectile)
	
	var xForm : Transform2D = Transform2D(0, Vector2(0,0))
	
	PhysicsServer2D.area_set_transform(projectile.projectile_rid, xForm)
	
	PhysicsServer2D.area_set_space(projectile.projectile_rid, projectile._space)
	
	PhysicsServer2D.area_set_monitorable(projectile.projectile_rid, monitorable)
	
	PhysicsServer2D.area_set_area_monitor_callback(projectile.projectile_rid, projectile._on_area_entered)
	
	PhysicsServer2D.area_set_monitor_callback(projectile.projectile_rid, projectile._on_body_entered)
	
	PhysicsServer2D.area_set_collision_layer(projectile.projectile_rid, projectile_coll_layer)
	
	PhysicsServer2D.area_set_collision_mask(projectile.projectile_rid, projectile_coll_mask)
	
	#Rendering
	
	var texture_rid : RID = projectile_texture.get_rid()
	var texture_size : = projectile_texture.get_size()
	var draw_rect : Rect2 = Rect2(-texture_size / 2, texture_size)
	
	projectile.canvas_item = RenderingServer.canvas_item_create()
	
	projectile.p_texture_rid = texture_rid
	
	projectile.p_texture_size = texture_size
	
	projectile.draw_rect = draw_rect
	
	projectile.z_index = z_index
	
	RenderingServer.canvas_item_set_parent(projectile.canvas_item, ProjectileServer.get_window().world_2d.canvas)
	
	RenderingServer.canvas_item_set_z_index(projectile.canvas_item, z_index)
	
	return projectile
	
	
	
	
	
	
	
