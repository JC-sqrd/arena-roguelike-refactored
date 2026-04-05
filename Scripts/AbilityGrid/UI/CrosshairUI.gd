class_name CrosshairUI extends Control

@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	pass

func initialize():
	EventServer.weapon_attack_started.connect(_on_weapon_attack_started)
	pass

func _on_weapon_attack_started(weapon_controller : WeaponController):
	animation_player.stop()
	animation_player.play("crosshair_attacked")
	pass

func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
	pass
