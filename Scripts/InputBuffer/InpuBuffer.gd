class_name InputBuffer extends RefCounted

var buffer_time : float = 0.25
var buffered : bool = false
var timer : float = 0


func update_buffer(delta : float):
	if !buffered:
		return
	
	timer += delta
	
	if timer >= buffer_time:
		timer = 0
		buffered = false
	pass

func buffer_input():
	buffered = true
	pass
