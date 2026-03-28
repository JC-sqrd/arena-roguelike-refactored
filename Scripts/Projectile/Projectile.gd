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
var range : float = 64
var _range_counter : float = 0
var angle : float = 0
var active : bool = true

var _pierce_count : int = 0

var movement : ProjectileMovement
var effects : Array[Effect]
var context : Dictionary[StringName, Variant]

var hit_log : Array[RID]

signal projectile_hit(hit : RID)
signal to_free()

func process_projectile(delta : float):
	if active:
		movement.update_movement(delta)
	
	update_render()
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
	
	if hit_log.has(area_rid):
		hit_log.erase(area_rid)
		return
		
	if _pierce_count >= pierce:
		active = false
		ProjectileServer.to_free(projectile_rid)
	
	
	_pierce_count += 1
	
	projectile_hit.emit(area_rid)
	
	#for effect in effects:
		#EffectServer.receive_effect(area_rid, effect, context)
		#EventServer.effect_hit.emit(area_rid, effect, context)
	
	hit_log.append(area_rid)
	pass

func _on_body_entered(status : PhysicsServer2D.AreaBodyStatus, body_rid : RID, instance_id : int, body_shape_idx : int, self_shape_idx : int):
	pass

func free_projectile():
	to_free.emit()
	effects.clear()
	hit_log.clear() 
	context.clear()
	active = false
	movement.projectile = null
	movement = null
	
	for connection in projectile_hit.get_connections():
		projectile_hit.disconnect(connection.callable)
	
	if projectile_rid.is_valid():
		print("FREE PROJECTILE PHYSICS RID")
		PhysicsServer2D.free_rid(projectile_rid)
	if shape_rid.is_valid():
		PhysicsServer2D.free_rid(shape_rid)
	if canvas_item.is_valid():
		RenderingServer.free_rid(canvas_item)
	pass
