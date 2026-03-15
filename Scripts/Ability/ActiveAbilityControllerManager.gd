class_name ActiveAbilityControllerManager extends AbilityControllerManager


@export var default_ability_data : Array[ActiveAbilityData]

@export var ability_one : ActiveAbilityData

var controllers : Dictionary[ActiveAbilityData, ActiveAbilityController]
var caster : Entity



func initialize(caster : Entity):
	self.caster = caster
	for data in default_ability_data:
		var ability_data = data.duplicate()
		var controller : ActiveAbilityController = ability_data.build_abiltiy_controller()
		add_controller(controller)
		pass
	
	ability_one = ability_one.duplicate()
	var ability_one_controller : ActiveAbilityController = ability_one.build_abiltiy_controller()
	add_controller(ability_one_controller)
	controllers[ability_one] = ability_one_controller
	pass


func add_controller(controller : AbilityController):
	controller.initialize(caster)
	add_child(controller)
	pass

func remove_controller():
	pass

func _unhandled_input(event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("active_ability_1"):
		var controller : ActiveAbilityController = controllers.get(ability_one)
		controller.start_ability()
		pass
	
	pass
