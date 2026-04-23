@abstract
class_name AttackExecute extends Node

var active : bool = false
var context : Dictionary[StringName, Variant]
var executing : bool = false

@abstract
func initialize()

@abstract
func execute(context : Dictionary[StringName, Variant])

@abstract
func finish_execute()
