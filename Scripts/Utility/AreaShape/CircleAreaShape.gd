class_name CircleAreaShape extends AreaShape

@export var radius : float = 16

var _shape_rid : RID

func set_area_shape(area_rid : RID) -> RID:
	_shape_rid = PhysicsServer2D.circle_shape_create()
	PhysicsServer2D.shape_set_data(_shape_rid, radius)
	PhysicsServer2D.area_add_shape(area_rid, _shape_rid)
	return _shape_rid
