class_name MeleeAttackExecute extends AttackExecute

var melee_anim_player : MeleeAnimationPlayer
var melee_hitbox : Area2D
var melee_context : MeleeAttackExecuteContext
var successful_queries : Array[RID]



func initialize():
	pass


func execute(context : AttackExecuteContext):
	if (melee_anim_player and melee_hitbox) == null:
		printerr("Melee Execute not initialized(MeleeAnimationPlayer and MeleeHitbox needed)")
		return
	
	self.context = context
	
	melee_context = context as MeleeAttackExecuteContext
	
	melee_anim_player.play("attack")
	active = true
	pass

func finish_execute():
	active = false
	successful_queries.clear()
	print("MELEE ATTACK FINISH EXECUTING")
	pass

func set_melee_anim_player(melee_anim_player : MeleeAnimationPlayer):
	self.melee_anim_player = melee_anim_player
	self.melee_anim_player.animation_finished.connect(_on_windup_anim_finished)
	self.melee_anim_player.animation_finished.connect(_on_attack_anim_finished)
	self.melee_anim_player.animation_finished.connect(_on_recovery_anim_finished)
	pass

func set_melee_hitbox(hitbox : Area2D):
	self.melee_hitbox = hitbox
	melee_hitbox.area_entered.connect(_on_area_entered)
	pass


func _on_windup_anim_finished(anim : StringName):
	if anim == "windup":
		melee_anim_player.play("attack")
		pass
	pass

func _on_attack_anim_finished(anim : StringName):
	if anim == "attack":
		melee_anim_player.play("recovery")
	
		var queries: Array[Area2D] = melee_hitbox.get_overlapping_areas()
		
		for query in queries:
			var rid : RID = query.get_rid()
			for effect in context.attack_effects:
				EffectServer.receive_effect(rid, effect, context.effects_context)
			pass
	
	pass

func _on_recovery_anim_finished(anim : StringName):
	if anim == "recovery":
		finish_execute()
		pass
	pass

func _on_area_entered(area : Area2D):
	print("MELEE ATTACK EXECUTE AREA ENTERED")
	var rid : RID = area.get_rid()
	if successful_queries.has(area.get_rid()) or !active:
		return
	successful_queries.append(rid)
	print("MELEE ATTACK EXECUTED")
	for effect in context.attack_effects:
		EffectServer.receive_effect(rid, effect, context.effects_context)
	pass

func _on_area_exited(area : Area2D):
	pass
