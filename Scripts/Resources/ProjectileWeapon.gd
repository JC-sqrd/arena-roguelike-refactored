class_name ProjectileWeapon extends Weapon

@export var weapon_scene : PackedScene
@export var projectile_template : ProjectileTemplate
@export_category("Attack Damage Stat")
@export var damage_stat : StatTemplate = StatTemplate.new()
@export_category("Attack Speed Stat")
@export var attack_speed_stat : StatTemplate = StatTemplate.new()
@export_category("Weapon Animation")
@export var action_time_ratio : float = 0 

var projectile_weapon_controller : ProjectileWeaponController


func equip(context : EquipContext):
	
	wielder = context.wielder
	wielder_stats = context.wielder_stats
	
	#Instantiate melee weapon node and set its attack strategy
	projectile_weapon_controller = weapon_scene.instantiate() as ProjectileWeaponController
	projectile_weapon_controller.weapon_id = item_id + "_" +str(projectile_weapon_controller.get_instance_id())
	projectile_weapon_controller.projectile_template = projectile_template
	
	context.hold_anchor.add_child(projectile_weapon_controller)
	
	_weapon_stats = generate_weapon_stats() 
	projectile_weapon_controller.melee_stats = _weapon_stats
	
	_weapon_stats.initialize()
	
	_weapon_context = generate_effect_context(_weapon_stats)
	
	_weapon_effects = generate_effects(_weapon_context)
	
	projectile_weapon_controller.wielder_stats = wielder_stats
	projectile_weapon_controller.weapon_stats = _weapon_stats
	projectile_weapon_controller.effects = _weapon_effects
	projectile_weapon_controller.effect_context = _weapon_context
	projectile_weapon_controller.action_time_ratio = action_time_ratio
	projectile_weapon_controller.controller_context = _weapon_context
	
	projectile_weapon_controller.initialize(wielder)
	
	active_controller = projectile_weapon_controller
	equipped.emit()
	pass


func unequip():
	wielder_stats = null
	active_controller = null
	projectile_weapon_controller.queue_free()
	unequipped.emit()
	pass

func generate_effect_context(weapon_stats : Stats) -> Dictionary[StringName, Variant]:
	var context : Dictionary[StringName, Variant]
	context["source"] = wielder
	context["source_stats"] = wielder_stats
	context["wielder_stats"] = wielder_stats
	context["weapon_stats"] = weapon_stats
	return context

func generate_weapon_stats() -> Stats:	
	var stats_template : StatsTemplate = StatsTemplate.new()
	stats_template.stat_templates.append(damage_stat)
	stats_template.stat_templates.append(attack_speed_stat)
	
	var stats : Stats = Stats.new()
	stats.stats_template = stats_template
	return stats

func generate_effects(context : Dictionary[StringName, Variant])-> Array[Effect]:
	var effects : Array[Effect]
	for effect_template in effect_templates:
		effects.append(effect_template.build_effect(context))
		pass
	return effects
