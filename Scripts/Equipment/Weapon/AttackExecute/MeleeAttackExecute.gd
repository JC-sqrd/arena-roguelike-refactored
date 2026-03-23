class_name MeleeAttackExecute extends AttackExecute

var melee_anim_player : MeleeAnimationPlayer
var melee_hitbox : HitBox
var melee_context : Dictionary[StringName, Variant]
var successful_queries : Array[RID]

var action_time_ratio : float = 0

var _curr_anim_length : float
var _curr_anim_pos : float = 0 
var _action_time : float

var active_hit : bool = false

signal hit(hits : Array[RID])
signal finished_executing()

func initialize():
	pass


func execute(context : Dictionary[StringName, Variant]):
	if (melee_anim_player and melee_hitbox) == null:
		printerr("Melee Execute not initialized(MeleeAnimationPlayer and MeleeHitbox needed)")
		return
	
	self.context = context
	
	melee_context = context
	
	action_time_ratio = context.action_time_ratio
	melee_anim_player.speed_scale = maxf(1, context.anim_speed) 
	melee_anim_player.play("attack")
	active = true
	active_hit = true
	pass

func _process(delta: float) -> void:
	if !active:
		return
		
	if melee_anim_player.current_animation == "attack":
		if melee_anim_player.is_playing() and active_hit:
			_curr_anim_length = melee_anim_player.current_animation_length
			_curr_anim_pos = melee_anim_player.current_animation_position
			_action_time = _curr_anim_length * action_time_ratio
			if _curr_anim_pos >= _action_time:
				var hits : Array[RID] = melee_hitbox.query_hits(false)
				#melee_hitbox.query_hitbox(false, hits)
				send_effects_to_hits(hits)
				if hits.size() > 0:
					EventServer.weapon_hit.emit(hits, melee_hitbox.effects, melee_context)
					hit.emit(hits)
				#query_hitbox()
				active_hit = false
			pass

func finish_execute():
	active = false
	successful_queries.clear()
	finished_executing.emit()
	pass

func set_melee_anim_player(melee_anim_player : MeleeAnimationPlayer):
	self.melee_anim_player = melee_anim_player
	self.melee_anim_player.animation_finished.connect(_on_attack_anim_finished)
	pass

func set_melee_hitbox(hitbox : HitBox):
	self.melee_hitbox = hitbox
	#melee_hitbox.area_entered.connect(_on_area_entered)
	pass


func _on_attack_anim_finished(anim : StringName):
	if anim == "attack":
		melee_anim_player.play("recovery")
		finish_execute()
	pass


func send_effects_to_hits(hits : Array[RID]):
	for hit in hits:
		for effect in melee_hitbox.effects:
			EffectServer.receive_effect(hit, effect, context)
	pass
