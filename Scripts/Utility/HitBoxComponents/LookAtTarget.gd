class_name LookAtTarget extends HitboxComponent


var targets : Array[RID]
var hitbox : HitBox

var tween_duration : float = 0.1

var _tween : Tween
var _curr_target : Entity

func _init(hitbox : HitBox):
	self.hitbox = hitbox
	pass


func look_at_closest_target(targets : Array[RID]):
	if targets.size() == 0:
		return
	
	_curr_target = EntityServer.active_entities[targets[0]]
	
	_tween =  hitbox.get_tree().create_tween()
	_tween.bind_node(hitbox)
	_tween.tween_property(hitbox, "rotation", Vector2.RIGHT.angle_to(_curr_target.global_position - hitbox.global_position), tween_duration)
	pass
