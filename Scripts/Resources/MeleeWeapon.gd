class_name MeleeWeapon extends Weapon


@export var attack_strategy : AttackStrategy

@export var weapon_scene : PackedScene
@export_category("Attack Damage Stat")
@export var damage_stat : StatTemplate = StatTemplate.new()
@export_category("Attack Speed Stat")
@export var attack_speed_stat : StatTemplate = StatTemplate.new()

var melee_node : MeleeWeaponNode


func equip(context : EquipContext):
	
	wielder_stats = context.wielder_stats
	
	#Instantiate melee weapon node and set its attack strategy
	melee_node = weapon_scene.instantiate() as MeleeWeaponNode
	melee_node.attack_strategy = attack_strategy
	
	context.hold_anchor.add_child(melee_node)
	
	_weapon_stats = generate_weapon_stats() 
	melee_node.add_child(_weapon_stats)
	
	_weapon_stats.initialize()
	
	_weapon_context = generate_effect_context(_weapon_stats)
	
	_weapon_effects = generate_effects(_weapon_context)
	
	melee_node.wielder_stats = wielder_stats
	melee_node.weapon_stats = _weapon_stats
	melee_node.effects = _weapon_effects
	melee_node.effect_context = _weapon_context
	
	melee_node.initialize()
	
	equipped.emit()
	pass


func unequip():
	wielder_stats = null
	melee_node.queue_free()
	unequipped.emit()
	pass

func generate_effect_context(weapon_stats : Stats) -> Dictionary[StringName, Variant]:
	var context : Dictionary[StringName, Variant]
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
