extends Node2D

var active_areas : Dictionary[RID, Area]
var area_to_node : Dictionary[Area, Node]

var free_queue : Array[RID]

var _keys : Array[RID]


static func set_area_position(area : Area, position : Vector2):
	area.global_position = position
	area.xForm = Transform2D(area.angle, area.global_position)
	PhysicsServer2D.area_set_transform(area.area_rid, area.xForm)
	pass

func register_area(rid : RID, area : Area):
	active_areas[rid] = area
	area.active = true
	pass

func _physics_process(delta: float) -> void:
	_keys = active_areas.keys()
	
	for key in _keys:
		if active_areas.has(key):
			var area : Area = active_areas.get(key)
			area.update_position(delta)
		pass
	
	for rid in free_queue:
		if active_areas.has(rid):
			var area : Area = active_areas.get(rid)
			area.active = false
			area.free_area()
			active_areas.erase(rid)
		free_queue.erase(rid)
	pass

func to_free(rid : RID):
	free_queue.append(rid)
	PhysicsServer2D.area_set_collision_layer(rid, 0)
	PhysicsServer2D.area_set_collision_mask(rid, 0)
	PhysicsServer2D.area_set_monitorable(rid, false)
	pass
