class_name AttackInputListener extends Node


var listening_for_input : bool = false
var stats : Stats

func initialize(stats : Stats):
	self.stats = stats
	listening_for_input = true
	pass

#func _unhandled_input(event: InputEvent) -> void:
	#if !listening_for_input:
		#return
		#
	#if event is InputEventMouseButton and Input.is_action_just_pressed("attack"):
		#print("START ATTACK INPUT!")
		#pass
	#pass

func generate_attack_input():
	pass
