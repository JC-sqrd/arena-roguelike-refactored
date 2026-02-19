@abstract
class_name AttackExecute extends Node

var active : bool = false
var context : AttackExecuteContext

@abstract
func initialize()

@abstract
func execute(context : AttackExecuteContext)

@abstract
func finish_execute()
