class_name Stats extends Node

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
	pass

func has(stat_id : StringName) -> bool:
	return stat_dict.has(stat_id)

func has_tag(tag : StringName) -> bool:
	return tags.has(tag)

func get_stat(stat_id : StringName) -> Stat:
	if stat_dict.has(stat_id):
		return stat_dict[stat_id]
	return null
