class_name Stats extends RefCounted

enum DefinedStats {
	current_health,
	max_health, 
	move_speed,
	melee_damage,
	ability_damage,
	lethality,
	projectile_count
	}

@export var stats_template : StatsTemplate
@export var tags : Array[StringName]
var stat_dict : Dictionary[StringName, Stat]

signal tag_added(tag : StringName)

func add_tag(tag : StringName):
	if has_tag(tag):
		return
	tags.append(tag)
	tag_added.emit(tag)
	pass

func initialize():
	stat_dict = stats_template.build_stats_from_template()
	#initialize_defined_stats()
	pass

func has(stat_id : StringName) -> bool:
	return stat_dict.has(stat_id)

func has_tag(tag : StringName) -> bool:
	return tags.has(tag)

func get_stat(stat_id : StringName) -> Stat:
	if stat_dict.has(stat_id):
		return stat_dict[stat_id]
	return null

func initialize_defined_stats():
	for key in DefinedStats.keys():
		if !stat_dict.has(key):
			var stat : Stat = Stat.new(key, 0)
			stat.name = str(key).capitalize()
			stat_dict[key] = stat
			pass
	pass
