@abstract
class_name AttackExecute extends Node

var controller : WeaponController
var active : bool = false
var executing : bool = false


func initialize(controller : WeaponController):
	self.controller = controller
	pass

@abstract
func execute()

@abstract
func finish_execute()


func generate_execute_context():
	
	pass
