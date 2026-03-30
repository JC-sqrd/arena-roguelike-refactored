class_name GrantGoldOnDeathListener extends OnDeathEventListener

@export var amount : float = 0


func initialize(entity : Entity):
	self.entity = entity
	EventServer.entity_died.connect(_on_entity_died)
	pass

func _on_entity_died(entity : Entity, context : Dictionary[StringName, Variant]):
	if self.entity == entity:
		CurrencyServer.add_gold(amount)
		pass
	pass
