class_name ActiveAbilityController extends AbilityController


@export var ability_data : Array[AbilityData]

@export var ability_1_data : ActiveAbilityData
var ability_1 : ActiveAbility

var abilities : Dictionary[StringName, ActiveAbility]

var current_ability : ActiveAbility

var active : bool = false

func initialize(caster : Entity):
	active = true
	ability_1 = ability_1_data.build_abiltiy()
	add_child(ability_1)
	ability_1.initialize(caster)
	pass

func add_ability():
	
	pass


func _unhandled_input(event: InputEvent) -> void:
	if !active:
		return
	
	if event is InputEventKey:
		if Input.is_action_just_pressed("active_ability_1"):
			if ability_1 != null:
				set_current_ability(ability_1)
				pass
			pass


func set_current_ability(ability : ActiveAbility):
	if current_ability == null:
		current_ability = ability
		current_ability.ability_finished.connect(on_current_ability_finished)
		current_ability.start()
	else:
		printerr("Cannot cast ability while another is still active.")
	pass

func on_current_ability_finished(ability : ActiveAbility):
	current_ability = null
	ability.ability_finished.disconnect(on_current_ability_finished)
	pass
