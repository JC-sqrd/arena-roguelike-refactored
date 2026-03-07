class_name TargetAreaDetector extends RefCounted

var targets : Array[RID]
var area : Area

signal target_entered(target : RID)
signal target_exited(target : RID)

func _init(area : Area):
	self.area = area
	self.area.set_area_enter_callback(_area_callback)
	pass

func update_position(position : Vector2):
	AreaServer.set_area_position(area, position)
	pass


func _area_callback(status : int, area_rid : RID, instance_id : int, area_shape_idx : int, self_shape_idx : int):
	#Area Entered
	if status == 0:
		targets.append(area_rid)
		target_entered.emit(area_rid)
		pass
	else:
		if targets.has(area_rid):
			targets.erase(area_rid)
			target_exited.emit(area_rid)
	pass

func _notification(what : int):
	if what == NOTIFICATION_PREDELETE:
		area.free_area()
		pass
	pass
