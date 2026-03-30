class_name OnDeathEventListener extends Resource


var entity : Entity

func initialize(entity : Entity):
	self.entity = entity
	pass


func cleanup():
	entity = null
	pass
