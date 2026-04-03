class_name PlayerHealthBar extends TextureProgressBar

var _player_entity : Entity

func initialize(player_entity : Entity):
	_player_entity = player_entity
	player_entity.health_manager.current_health.value_changed.connect(_on_current_health_changed)
	var health_percent : float = _player_entity.health_manager.current_health.get_value() / _player_entity.health_manager.max_health.get_value()
	value = max_value * health_percent
	print("PLAYER MAX HEALTH: ",value)
	pass

func _on_current_health_changed(stat : Stat, context : Dictionary[StringName, Variant]):
	var health_percent : float = _player_entity.health_manager.current_health.get_value() / _player_entity.health_manager.max_health.get_value()
	value = max_value * health_percent
	pass


func _exit_tree() -> void:
	_player_entity = null
