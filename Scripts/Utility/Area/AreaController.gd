class_name AreaController extends Node2D

@export var area_template : AreaTemplate

var active : bool = false

var area : Area

func _process(delta: float) -> void:
	if !active:
		return

func initialize():
	area = area_template.build_area()
	area.parent_node = self
	AreaServer.register_area(area.area_rid, area)
	active = true
	pass

func set_area_enter_callback(callable : Callable):
	if area != null:
		PhysicsServer2D.area_set_area_monitor_callback(area.area_rid, callable)
	else:
		var _area : Area = area_template.build_area()
		PhysicsServer2D.area_set_area_monitor_callback(_area.area_rid, callable)
		area = _area
	pass

func set_body_enter_callback(callable : Callable):
	if area != null:
		PhysicsServer2D.area_set_monitor_callback(area.area_rid, callable)
	else:
		var _area : Area = area_template.build_area()
		PhysicsServer2D.area_set_monitor_callback(_area.area_rid, callable)
		area = _area
	pass

func activate_area():
	active = true
	area.active = true
	pass

func deactivate_area():
	active = false
	area.active = false
	pass

func _exit_tree() -> void:
	AreaServer.to_free(area.area_rid)
