class_name Interactable extends Node


@export var parent_node : Node2D
@export var area_template : AreaTemplate


var area : Area

signal interacted(interactor : Entity)

func _ready() -> void:
	area = area_template.build_area()
	area.is_static = true
	area.owner = self
	area.parent_node = parent_node
	AreaServer.set_area_position(area, parent_node.global_position)
	AreaServer.register_area(area.area_rid, area)
	pass

func interact(interactor : Entity):
	interacted.emit()
	pass


func _exit_tree() -> void:
	AreaServer.to_free(area.area_rid)
	pass
