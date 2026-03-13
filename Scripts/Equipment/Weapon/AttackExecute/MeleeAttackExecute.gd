class_name MeleeAttackExecute extends AttackExecute

var melee_anim_player : MeleeAnimationPlayer
var melee_hitbox : Area2D
var melee_context : MeleeAttackExecuteContext
var successful_queries : Array[RID]

signal hit(hits : Array[RID])
signal finished_executing()

func initialize():
	pass


func execute(context : AttackExecuteContext):
	if (melee_anim_player and melee_hitbox) == null:
		printerr("Melee Execute not initialized(MeleeAnimationPlayer and MeleeHitbox needed)")
		return
	
	self.context = context
	
	melee_context = context as MeleeAttackExecuteContext
	
	melee_anim_player.play("windup")
	active = true
	pass

func finish_execute():
	active = false
	successful_queries.clear()
	finished_executing.emit()
	pass

func set_melee_anim_player(melee_anim_player : MeleeAnimationPlayer):
	self.melee_anim_player = melee_anim_player
	self.melee_anim_player.animation_finished.connect(_on_windup_anim_finished)
	self.melee_anim_player.animation_finished.connect(_on_attack_anim_finished)
	self.melee_anim_player.animation_finished.connect(_on_recovery_anim_finished)
	pass

func set_melee_hitbox(hitbox : Area2D):
	self.melee_hitbox = hitbox
	#melee_hitbox.area_entered.connect(_on_area_entered)
	pass


func _on_windup_anim_finished(anim : StringName):
	if anim == "windup":
		melee_anim_player.play("attack")
		query_hitbox()
		pass
	pass

func _on_attack_anim_finished(anim : StringName):
	if anim == "attack":
		melee_anim_player.play("recovery")
	pass

func _on_recovery_anim_finished(anim : StringName):
	if anim == "recovery":
		finish_execute()
		pass
	pass

func query_hitbox():
	var space_state : = melee_hitbox.get_world_2d().direct_space_state
	
	var hits : Array[RID]
	
	for child in melee_hitbox.get_children():
		if child is CollisionShape2D:
			var query : PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
			query.shape_rid = child.shape.get_rid()
			query.transform = child.global_transform
			query.collision_mask = melee_hitbox.collision_mask
			query.collide_with_areas = true
				
			var results = space_state.intersect_shape(query, 500)
				
			for result in results:
				hits.append(result.rid)
				pass
			pass
	
	
	if hits.size() > 0:
		for hit in hits:
			for effect in context.attack_effects:
				EffectServer.receive_effect(hit, effect, context.effects_context)
		hit.emit(hits)
	pass
