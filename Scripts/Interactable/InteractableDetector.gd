class_name InteractableDetector extends Node

@export var detector_area_template : AreaTemplate

var area : Area
var interactor : Entity
var parent_node : Node2D

var _near_interactables : Dictionary[Area, Interactable]

func initialize(interactor : Entity, parent_node : Node2D):
	self.interactor = interactor
	self.parent_node = parent_node
	area = detector_area_template.build_area()
	area.set_area_enter_callback(_on_area_entered)
	area.parent_node = parent_node
	AreaServer.register_area(area.area_rid, area)
	pass


func _on_area_entered(status : PhysicsServer2D.AreaBodyStatus, area_rid : RID, instance_id : int, area_shape_idx : int, self_shape_idx : int):
	if status == 0:
		print("INTERACTABLE ENTERED")
		var area : Area = AreaServer.active_areas.get(area_rid)
		if area != null:
			if area.owner != null and area.owner is Interactable:
				_near_interactables[area] = area.owner
				pass
		print(str(_near_interactables))
		pass
		
	if status == 1:
		print("INTERACTABLE EXITED")
		var area : Area = AreaServer.active_areas.get(area_rid)
		if area != null:
			if _near_interactables.has(area):
				_near_interactables.erase(area)
				pass
		print(str(_near_interactables))
	pass

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		_near_interactables.keys().sort_custom(
			func(a, b):
				var dist_a : float = a.global_position.distance_squared_to(parent_node.global_position)
				var dist_b : float = b.global_position.distance_squared_to(parent_node.global_position)
				return dist_a < dist_b
		)
		if _near_interactables.size() > 0:
			_near_interactables[_near_interactables.keys()[0]].interact(interactor)
			pass
	pass
