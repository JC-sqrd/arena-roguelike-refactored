@abstract
class_name AreaShape extends Resource


func set_area_shape(area_rid : RID) -> RID:
	return PhysicsServer2D.circle_shape_create()
