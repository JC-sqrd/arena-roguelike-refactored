class_name AbilityIconUI extends TextureRect

@onready var cooldown_progress_bar: TextureProgressBar = $CooldownProgressBar

var active_ability : ActiveAbilityController

var cooldown_timer : CooldownTimer
var cooldown : bool = false
var cooldown_ratio : float = 0

func initialize(active_ability : ActiveAbilityController, tx : Texture = null):
	self.active_ability = active_ability
	
	cooldown_timer = active_ability.cooldown_timer
	
	cooldown_timer.cooldown_start.connect(_on_cooldown_start)
	cooldown_timer.timeout.connect(_on_timeout)
	
	if tx != null:
		texture = tx
	pass


func _process(delta: float) -> void:
	if cooldown:
		cooldown_ratio = cooldown_timer.time_left / cooldown_timer.cooldown
		cooldown_progress_bar.value = cooldown_progress_bar.max_value * cooldown_ratio
		pass
	pass

func _on_cooldown_start():
	cooldown = true
	cooldown_progress_bar.value = cooldown_progress_bar.max_value
	pass

func _on_timeout():
	cooldown = true
	cooldown_progress_bar.value = 0
	pass

func calculate_cooldown_step(cd_time : float = 0) -> float:
	return cooldown_progress_bar.max_value / cd_time
	  
