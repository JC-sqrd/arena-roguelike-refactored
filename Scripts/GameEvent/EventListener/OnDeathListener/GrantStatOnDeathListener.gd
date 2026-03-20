class_name GrantStatOnDeath extends OnDeathEventListener

@export var stat_id : StringName
@export var grant_value : float = 0

func initialize(entity : Entity):
	self.entity = entity
	EventServer.entity_died.connect(on_death)
	pass


func on_death(death_event : EntityDeathEvent):
	if death_event.entity == entity:
		var slayer : Entity = death_event.death_context.source
		slayer.stats.get_stat(stat_id).add(grant_value)
		print("GRANT STAT TO: " + str(death_event.death_context.source))
		
		pass
	pass
