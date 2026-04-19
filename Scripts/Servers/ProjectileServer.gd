extends Node2D

var active_projectiles : Dictionary[RID, Projectile]

var _keys : Array[RID]

var free_queue : Array[RID]

var debug : bool = false

func _ready() -> void:
	z_index = 100

func regiser_projectile(rid : RID, projectile : Projectile):
	active_projectiles[rid] = projectile
	projectile.initialized.emit()
	pass


func _physics_process(delta: float) -> void:
	queue_redraw()
	if active_projectiles.size() == 0:
		return
	
	if not free_queue.is_empty():
		var curr_free_queue : Array = free_queue.duplicate()
		free_queue.clear()
		for rid in curr_free_queue:
			if active_projectiles.has(rid):
				var projectile : Projectile = active_projectiles[rid]
				active_projectiles.erase(rid)
				if projectile != null:
					projectile.free_projectile()
	
	_keys.clear()
	_keys = active_projectiles.keys()
	
	for key in _keys:
		if active_projectiles.has(key):
			active_projectiles[key].process_projectile(delta)
			pass
		pass
	pass


func to_free(rid : RID):
	free_queue.append(rid)
	pass


func _draw() -> void:
	if debug:
		draw_line(Vector2.ZERO, get_global_mouse_position(), Color.CRIMSON, 1)
		draw_circle(get_global_mouse_position(), 4, Color.RED, true, 2)
	pass
