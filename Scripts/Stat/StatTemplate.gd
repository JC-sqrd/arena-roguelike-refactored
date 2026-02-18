class_name StatTemplate extends Resource

@export var name : String
@export var stat_id : StringName
@export var value : float = 0
@export var bonus_value : float = 0
@export var multiplier : float = 1



func build_stat() -> Stat:
	var stat : Stat = Stat.new(stat_id, value, name, bonus_value, multiplier)
	return stat
