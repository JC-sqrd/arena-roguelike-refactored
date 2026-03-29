#Entity Server
extends Node

var active_entities : Dictionary[RID, Entity]


var free_queue : Array[RID]

var _keys : Array[RID]

func _physics_process(delta: float) -> void:
	
	for entity_to_free in free_queue:
		if active_entities.has(entity_to_free):
			var entity : Entity = active_entities.get(entity_to_free)
			active_entities.erase(entity_to_free)
			entity.cleanup()
		pass
	free_queue.clear()
	
	#_keys.clear()
	#_keys = active_entities.keys()
	#
	#for key in _keys:
		#if active_entities.has(key):
			#var entity : Entity = active_entities.get(entity_to_free)
			##controller.update_cell_coords(delta)
			##controller.update_position(delta)
	pass

func register_entity(id : RID, entity : Entity):
	active_entities[id] = entity
	pass

func free_entity(id : RID):
	active_entities.erase(id)
	pass

func to_free(id : RID):
	free_queue.append(id)
