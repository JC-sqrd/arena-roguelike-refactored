extends Node


var active_items : Dictionary[int, RenderItem]

func register_item(id : int, item : RenderItem):
	active_items[id] = item
	pass


func update_render_item_positions():
	
	pass
