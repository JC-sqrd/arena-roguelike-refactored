extends WeaponUpgradeNode


@export var target_area_template : AreaTemplate
@export var ball_effect_template : EffectTemplate


var max_ball_count : int = 30
var target_area : Area

const SPIRITBALL_HITBOX = preload("uid://dyr121in3iib7")

var active_balls : Dictionary[HitBox, Array]

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
	
	if active_balls.is_empty():
		return
	
	for ball in active_balls:
		var data : Array[Variant] = active_balls[ball]
		var dir : Vector2 = data[0]
		var area : Area = data[1]
		data[2] -= delta
		if data[2] <= 0 or data[3] <= 0:
			active_balls.erase(ball)
			area.free_area()
			ball.queue_free()
			data.clear()
		else:
			ball.global_position += dir * 400 * delta
			area.set_global_position(ball.global_position)
			hitbox_hit(ball, ball.query_hits(), active_balls[ball])
		pass
	

func _on_knockback_applied(data : Dictionary[StringName, Variant], context : Dictionary[StringName, Variant]):
	if active_balls.size() >= max_ball_count:
		return
	
	if context.has("weapon_id") and context.weapon_id == upgrade_tree.weapon_controller.weapon_id:
		var hitbox : HitBox = SPIRITBALL_HITBOX.instantiate() 
		var wielder_pos : Vector2 = upgrade_tree.weapon_controller.wielder.global_position
		var target_pos : Vector2 = EntityServer.active_entities[context.target_rid].global_position
		var dir : Vector2 = (target_pos - wielder_pos).normalized() 
		var lifetime : float = 10
		var bounce : int = 5
		var hitbox_area : Area = target_area_template.build_area()
		var hitbox_data : Array[Variant] = [dir, hitbox_area, lifetime, bounce]
		
		hitbox.global_position = target_pos
		hitbox.rotate(dir.angle())
		active_balls[hitbox] = hitbox_data
		get_tree().root.add_child(hitbox)
		pass
	pass

func hitbox_hit(hitbox : HitBox, hits : Array[RID], hitbox_data : Array[Variant]):
	if hits.is_empty():
		return
	
	var anim_sprite : AnimatedSprite2D = hitbox.node_components.get("spiritball_anim_sprite")
	anim_sprite.stop()
	anim_sprite.play("bounce")
	
	var area : Area = hitbox_data[1]
	var context : Dictionary[StringName, Variant] = upgrade_tree.weapon_controller.generate_controller_context()
	for hit in hits:
		EffectServer.receive_effect(hit, ball_effect_template.build_effect(context), context)
	
	hitbox_data[3] -= 1
	
	if hitbox_data[3] <= 0:
		active_balls.erase(hitbox)
		hitbox.queue_free()
		hitbox_data.clear()
		return
	
	var near_entities_rid : Array[RID] = area.query_area()
	if !near_entities_rid.is_empty():
		var pos : Vector2 = hitbox.global_position
		var target_pos : Vector2 = EntityServer.active_entities[near_entities_rid[0]].global_position
		var dir : Vector2 = (target_pos - pos).normalized() 
		hitbox.rotate(dir.angle())
		hitbox_data[0] = dir
	else:
		active_balls.erase(hitbox)
		hitbox.queue_free()
		hitbox_data.clear()
	pass
