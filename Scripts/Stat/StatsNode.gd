class_name StatsNode extends Node

@export var stats_template : StatsTemplate
@export var tags : Array[StringName]

var stats : Stats

func build_stats() -> Stats:
	stats = Stats.new()
	stats.stats_template = stats_template
	stats.initialize()
	return stats
