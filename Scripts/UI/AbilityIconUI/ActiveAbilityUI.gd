class_name ActiveAbilityUI extends Control

@onready var ability_icon: AbilityIconUI = %AbilityIcon
@onready var ability_key_label: Label = %AbilityKeyLabel


func initialize(active_ability : ActiveAbilityController, ability_key : StringName, tx : Texture = null):
	ability_icon.initialize(active_ability, tx)
	var events : Array[InputEvent] = InputMap.action_get_events(ability_key)
	if !events.is_empty():
		var event : InputEvent = events[0]
		if event is InputEventKey:
			var code : int = event.physical_keycode if event.keycode == 0 else event.keycode
			var key_name : String = OS.get_keycode_string(code)
			ability_key_label.text = key_name
			pass
		pass
	pass
