@abstract
class_name RenderItem extends Node

var canvas_item : RID
var viewport_rid : RID
var global_position : Vector2


func create_canvas_item():
	self.global_position = Vector2.ZERO
	
	var world_canvas : RID = get_window().world_2d.canvas
	
	canvas_item = RenderingServer.canvas_item_create()
	
	RenderingServer.canvas_item_set_parent(canvas_item, world_canvas)
	pass

func update_render():
	
	pass

func update_position():
	pass
