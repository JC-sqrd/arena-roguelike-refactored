class_name GrantGoldOnDeathListener extends OnDeathEventListener

@export var amount : float = 0


func initialize(entity : Entity):
	self.entity = entity
	EventServer.entity_died.connect(_on_entity_died)
	pass


func _on_entity_died(death_event : EntityDeathEvent):
	if death_event.entity == entity:
		GoldServer.add_gold(amount)
		pass
	pass
