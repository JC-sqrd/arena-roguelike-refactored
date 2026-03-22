class_name ActiveAbilityControllerManager extends AbilityControllerManager


@export var default_ability_data : Array[ActiveAbilityData]

@export var ability_one : ActiveAbilityData
@export var ability_two : ActiveAbilityData

var controllers : Dictionary[ActiveAbilityData, ActiveAbilityController]
var caster : Entity

var ability_1_input_buffer = InputBuffer
var ability_2_input_buffer = InputBuffer

func initialize(caster : Entity):
	self.caster = caster
	for data in default_ability_data:
		var ability_data = data.duplicate()
		var controller : ActiveAbilityController = ability_data.build_abiltiy_controller()
		add_controller(controller)
		pass
	
	ability_1_input_buffer = InputBuffer.new()
	ability_one = ability_one.duplicate(true)
	var ability_one_controller : ActiveAbilityController = ability_one.build_abiltiy_controller()
	add_controller(ability_one_controller)
	controllers[ability_one] = ability_one_controller
	
	ability_2_input_buffer = InputBuffer.new()
	ability_two = ability_two.duplicate(true)
	var ability_two_controller : ActiveAbilityController = ability_two.build_abiltiy_controller()
	add_controller(ability_two_controller)
	controllers[ability_two] = ability_two_controller
	pass


func _process(delta: float) -> void:
	
	if ability_1_input_buffer.buffered and caster.can_cast:
		var controller : ActiveAbilityController = controllers.get(ability_one)
		controller.start_ability()
		ability_1_input_buffer.buffered = false
		pass
	
	if ability_2_input_buffer.buffered and caster.can_cast:
		var controller : ActiveAbilityController = controllers.get(ability_two)
		controller.start_ability()
		ability_2_input_buffer.buffered = false
	pass

	
	
	ability_1_input_buffer.update_buffer(delta)

func add_controller(controller : AbilityController):
	controller.initialize(caster)
	add_child(controller)
	pass

func remove_controller():
	pass

func _unhandled_input(event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("active_ability_1"):
		ability_1_input_buffer.buffer_input()
		pass
	
	if Input.is_action_just_pressed("active_ability_2"):
		ability_2_input_buffer.buffer_input()
	
	pass
