class_name EntityDeathEvent extends GameEvent

var death_context : Dictionary[StringName, Variant]
var entity : Entity

func _init(entity : Entity = null, context : Dictionary[StringName, Variant]= {}) -> void:
	self.entity = entity
	death_context = context
	pass

func on_death(entity : Entity, context : Dictionary[StringName, Variant]):
	self.entity = entity
	death_context = context
	pass


func invoke_event(context : Dictionary[StringName, Variant] = {}):
	
	pass
