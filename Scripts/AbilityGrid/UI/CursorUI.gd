class_name CursorUI extends Control


@export var exempted_children : Array[Node]


func clear():
	for child in get_children():
		if !exempted_children.has(child):
			child.queue_free()
	pass

func follow_mouse_pos(mouse_pos : Vector2):
	position = mouse_pos
	pass

func rotate_children_clockwise():
	for child in get_children():
		if child is Control:
			child.rotation_degrees += 90
		pass
	pass
