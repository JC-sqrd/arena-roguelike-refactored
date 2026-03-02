class_name CursorUI extends Control


func clear():
	for child in get_children():
		child.queue_free()
	pass

func follow_mouse_pos(mouse_pos : Vector2):
	position = mouse_pos
	pass
