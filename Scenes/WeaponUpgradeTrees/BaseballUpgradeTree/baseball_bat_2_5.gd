extends WeaponUpgradeNode


@export var target_area_template : AreaTemplate
@export var ball_effect_template : EffectTemplate


var max_ball_count : int = 30
var target_area : Area

const SPIRITBALL_HITBOX = preload("uid://dyr121in3iib7")

#var active_balls : Dictionary[HitBox, Array]
var active_balls : Array[Array]
var free_queue : Array[Array]

func apply_upgrade():
	target_area = target_area_template.build_area()
	EventServer.knockback_applied.connect(_on_knockback_applied)
	pass

func remove_upgrade():
	EventServer.knockback_applied.disconnect(_on_knockback_applied)
	pass

func _physics_process(delta: float) -> void:
	if !applied:
		return
	
	for i in range(free_queue.size()):
		active_balls.erase(free_queue[i])
		free_queue[i][0].queue_free()
		free_queue[i].clear()
		pass
	free_queue.clear()
	
	if active_balls.is_empty():
		return
	
	
	for i in range(active_balls.size()):
		var data : Array[Variant] = active_balls[i]
		var ball : HitBox = data[0]
		var dir : Vector2 = data[1]
		var area : Area = data[2]
		data[3] -= delta
		if data[3] <= 0 or data[4] <= 0:
			free_queue.append(data)
		else:
			ball.global_position += dir * 400 * delta
			area.set_global_position(ball.global_position)
			hitbox_hit(ball, ball.query_hits(), data, i)
		pass
	

func _on_knockback_applied(data : Dictionary[StringName, Variant], context : Dictionary[StringName, Variant]):
	if active_balls.size() >= max_ball_count:
		free_queue.append(active_balls.pop_back())
	
	if context.has("weapon_id") and context.weapon_id == upgrade_tree.weapon_controller.weapon_id:
		var hitbox : HitBox = SPIRITBALL_HITBOX.instantiate() 
		var wielder_pos : Vector2 = upgrade_tree.weapon_controller.wielder.global_position
		var target_pos : Vector2 = EntityServer.active_entities[context.target_rid].global_position
		var dir : Vector2 = (target_pos - wielder_pos).normalized() 
		var lifetime : float = 10
		var bounce : int = 20
		var hitbox_area : Area = target_area_template.build_area()
		var hitbox_data : Array[Variant] = [hitbox, dir, hitbox_area, lifetime, bounce]
		
		hitbox.global_position = target_pos
		hitbox.rotate(dir.angle())
		#active_balls[hitbox] = hitbox_data
		active_balls.append(hitbox_data)
		get_tree().root.add_child(hitbox)
		pass
	pass

func hitbox_hit(hitbox : HitBox, hits : Array[RID], hitbox_data : Array[Variant], idx : int):
	if hits.is_empty():
		return
	
	var anim_sprite : AnimatedSprite2D = hitbox.node_components.get("spiritball_anim_sprite")
	anim_sprite.stop()
	anim_sprite.play("bounce")
	
	var area : Area = hitbox_data[2]
	var context : Dictionary[StringName, Variant] = upgrade_tree.weapon_controller.generate_controller_context()
	for hit in hits:
		EffectServer.receive_effect(hit, ball_effect_template.build_effect(context), context)
	
	#Ball bounce
	hitbox_data[4] -= 1
	
	if hitbox_data[4] <= 0:
		free_queue.append(hitbox_data)
		#active_balls.erase(hitbox_data)
		#hitbox.queue_free()
		#hitbox_data.clear()
		return
	
	var near_entities_rid : Array[RID] = area.query_area()
	if !near_entities_rid.is_empty():
		var pos : Vector2 = hitbox.global_position
		var target_pos : Vector2 = EntityServer.active_entities[near_entities_rid[0]].global_position
		var dir : Vector2 = (target_pos - pos).normalized() 
		hitbox.rotate(dir.angle())
		hitbox_data[1] = dir
	else:
		free_queue.append(hitbox_data)
		#active_balls.erase(hitbox_data)
		#hitbox.queue_free()
		#hitbox_data.clear()
	pass
