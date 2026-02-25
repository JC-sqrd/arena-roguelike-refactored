class_name AreaController extends Node

@export var area_template : AreaTemplate

var active : bool = false

var area : Area

var parent_node : Node2D

func _process(delta: float) -> void:
	if !active:
		return

func initialize(parent_node : Node2D):
	self.parent_node = parent_node
	area = area_template.build_area()
	area.parent_node = parent_node
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

func _exit_tree() -> void:
	AreaServer.to_free(area.area_rid)
