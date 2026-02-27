class_name WeaponController extends Node2D

var weapon_id : StringName
var wielder_stats : Stats
var weapon_stats : Stats
var listen_for_input : bool = false
var effects : Array[Effect]

signal attack_start()
signal attack_executed()
signal attack_end()



func initialize():
	pass

func start_attack():
	pass


func execute_attack():
	pass


func end_attack():
	pass
