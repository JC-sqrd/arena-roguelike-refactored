class_name MeleeAttackExecute extends AttackExecute

var melee_anim_player : MeleeAnimationPlayer
var melee_hitbox : HitBox
var melee_controller : MeleeWeaponController
var melee_context : Dictionary[StringName, Variant]
var successful_queries : Array[RID]

var action_time_ratio : float = 0

var _curr_anim_length : float
var _curr_anim_pos : float = 0 
var _action_time : float

var active_hit : bool = false

signal to_hit(hit : RID, weapon_effects : Array[Effect], context : Dictionary[StringName, Variant])
signal hit(hit : RID, weapon_effects : Array[Effect], context : Dictionary[StringName, Variant])
signal hits(hits : Array[RID], weapon_effects : Array[Effect], context : Dictionary[StringName, Variant])
signal finished_executing()

func initialize(controller : WeaponController):
	super(controller)
	melee_controller = controller
	pass


func execute():
	generate_execute_context()
	var context : Dictionary[StringName, Variant] = controller.controller_context
	if (melee_anim_player and melee_hitbox) == null:
		printerr("Melee Execute not initialized(MeleeAnimationPlayer and MeleeHitbox needed)")
		return
	
	melee_context = context
	melee_controller = context.weapon_controller
	
	action_time_ratio = context.action_time_ratio
	melee_anim_player.speed_scale = maxf(1, context.anim_speed) 
	melee_anim_player.play("attack")
	active = true
	active_hit = true
	pass

func generate_execute_context():
	controller.controller_context = controller.generate_controller_context()
	controller.controller_context.source = controller.wielder
	controller.controller_context.wielder_stats = controller.wielder_stats
	controller.effects.clear()
	controller.effects = controller.generate_effects(controller.controller_context)
	controller.controller_context.queries = controller.queries
	controller.controller_context.weapon_stats = controller.weapon_stats
	#print("WEAPON STATS: ", str(weapon_stats.stat_dict))
	controller.controller_context.anim_speed = controller.weapon_stats.get_stat("attack_speed").get_value()
	controller.controller_context.action_time_ratio = controller.action_time_ratio
	controller.controller_context.weapon_controller = controller

func _process(delta: float) -> void:
	if !active:
		return
		
	if melee_anim_player.current_animation == "attack":
		if melee_anim_player.is_playing() and active_hit:
			_curr_anim_length = melee_anim_player.current_animation_length
			_curr_anim_pos = melee_anim_player.current_animation_position
			_action_time = _curr_anim_length * action_time_ratio
			if _curr_anim_pos >= _action_time:
				var queried_hits : Array[RID] = melee_hitbox.query_hits(false)
				for queried_hit in queried_hits:
					var effects : Array[Effect] = melee_controller.generate_effects(melee_context)
					to_hit.emit(queried_hit, effects, melee_context)
					hit.emit(queried_hit, effects, melee_context)
					pass
				#hits.emit(queried_hits, effects, melee_context)
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
