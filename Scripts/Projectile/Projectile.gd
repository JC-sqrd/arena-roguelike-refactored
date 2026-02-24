class_name Projectile extends RefCounted

#Physics
var projectile_rid : RID
var shape_rid : RID

var _space : RID

#Rendering
var canvas_item : RID
var projectile_texture : Texture2D
var p_texture_size : Vector2
var p_texture_rid : RID
var draw_rect : Rect2
var texture_angle : float = 0
var z_index : int = 15

#Projectile Properties
var global_position : Vector2
var direction : Vector2 = Vector2(1,0)
var speed : float
var velocity : Vector2
var pierce : int = 0
var lifetime : float = 10
var angle : float = 0
var active : bool = true

var _lifetime_counter : float = 0

var movement : ProjectileMovement
var effects : Array[Effect]
var context : Dictionary[StringName, Variant]

func process_projectile(delta : float):
	
	movement.update_movement(delta)
	
	update_render()
	
	if _lifetime_counter >= lifetime:
		free_projectile()
		pass
	
	_lifetime_counter += delta
	pass

func update_render():
	var xForm : Transform2D = Transform2D(texture_angle, global_position)
	RenderingServer.canvas_item_set_transform(canvas_item, xForm)
	pass

func draw_projectile():
	RenderingServer.canvas_item_add_texture_rect(canvas_item, draw_rect, p_texture_rid)
	var xForm : Transform2D = Transform2D(texture_angle, global_position)
	RenderingServer.canvas_item_set_transform(canvas_item, xForm)
	pass

func _on_area_entered(status : PhysicsServer2D.AreaBodyStatus, area_rid : RID, instance_aid : int, area_shape_idx : int, self_shape_idx : int):
	for effect in effects:
		EffectServer.receive_effect(area_rid, effect, context)
	
	free_projectile()
	pass

func _on_body_entered(status : PhysicsServer2D.AreaBodyStatus, body_rid : RID, instance_id : int, body_shape_idx : int, self_shape_idx : int):
	
	pass

func free_projectile():
	active = false
	ProjectileServer.free_projectile(projectile_rid)
	if projectile_rid.is_valid():
		PhysicsServer2D.free_rid(projectile_rid)
	if shape_rid.is_valid():
		PhysicsServer2D.free_rid(shape_rid)
	if canvas_item.is_valid():
		RenderingServer.free_rid(canvas_item)
	pass
