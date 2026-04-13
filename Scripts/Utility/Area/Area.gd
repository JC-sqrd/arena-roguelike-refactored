class_name Area extends RefCounted

#Physics
var area_rid : RID
var shape_rid : RID

#Properties
var parent_node : Node2D
var global_position : Vector2
var direction : Vector2 = Vector2(1,0)
var angle : float = 0
var active : bool = true
var _space : RID
var coll_layer : int = 0
var coll_mask : int = 0
var owner : Node 
var xForm : Transform2D
var is_static : bool = false

func update_position(delta : float):
	if !active:
		return
	
	if is_static:
		return
	
	if parent_node != null:
		global_position = parent_node.global_position
	
	xForm = Transform2D(angle, global_position)
	PhysicsServer2D.area_set_transform(area_rid, xForm)
	pass

func set_global_position(pos : Vector2):
	global_position = pos
	xForm = Transform2D(angle, pos)
	PhysicsServer2D.area_set_transform(area_rid, xForm)
	pass

func _on_area_entered(status : PhysicsServer2D.AreaBodyStatus, area_rid : RID, instance_id : int, area_shape_idx : int, self_shape_idx : int):
	
	pass

func _on_body_entered(status : PhysicsServer2D.AreaBodyStatus, body_rid : RID, instance_id : int, body_shape_idx : int, self_shape_idx : int):
	
	pass

func query_area() -> Array[RID]:
	var space_state : = PhysicsServer2D.space_get_direct_state(_space)
	
	var hits : Array[RID]
	
	#var new_hits : Array[RID]
	
	var results : Array[Dictionary]
	
	var query : PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
	query.shape_rid = shape_rid
	query.transform = xForm
	query.collision_mask = coll_mask
	query.collide_with_areas = true
	
	results = space_state.intersect_shape(query, 500)
	
	for result in results:
		var result_rid : RID = result.rid
		hits.append(result_rid)
		
	#	if !hit_log.has(result_rid):
	#		new_hits.append(result_rid)
		
	#	if log_hit:
	#		hit_log.append(result_rid)
	#		pass
	
	#for hit in hit_log:
	#	if !hits.has(hit):
	#		hit_log.erase(hit)
	#		pass
	#	pass
	
	return hits


func set_area_enter_callback(callable : Callable):
	PhysicsServer2D.area_set_area_monitor_callback(area_rid, callable)
	pass

func set_body_enter_callback(callable : Callable):
	PhysicsServer2D.area_set_monitor_callback(area_rid, callable)
	pass

func set_coll_layer(layer : int):
	PhysicsServer2D.area_set_collision_layer(area_rid, layer)

func set_coll_mask(mask : int):
	PhysicsServer2D.area_set_collision_mask(area_rid, mask)

func free_area():
	PhysicsServer2D.free_rid(area_rid)
	PhysicsServer2D.free_rid(shape_rid)
	pass
