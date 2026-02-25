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

func update_position(delta : float):
	if !active:
		return
	
	if parent_node != null:
		global_position = parent_node.global_position
	
	var xForm : Transform2D = Transform2D(angle, global_position)
	#print("AREA GLOBAL POS: " + str(global_position))
	PhysicsServer2D.area_set_transform(area_rid, xForm)
	pass


func _on_area_entered(status : PhysicsServer2D.AreaBodyStatus, area_rid : RID, instance_aid : int, area_shape_idx : int, self_shape_idx : int):
	
	pass

func _on_body_entered(status : PhysicsServer2D.AreaBodyStatus, body_rid : RID, instance_id : int, body_shape_idx : int, self_shape_idx : int):
	
	pass

func free_area():
	PhysicsServer2D.free_rid(area_rid)
	PhysicsServer2D.free_rid(shape_rid)
	pass
