extends Control

func _ready() -> void:
	visible = false

func open_ui():
	visible = !visible

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == KEY_TAB and event.pressed:
		open_ui()
		pass
