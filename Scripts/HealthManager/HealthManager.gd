class_name HealthManager extends RefCounted

var max_health : Stat
var current_health : Stat

signal health_depleted()

func initialize(stats : Stats):
	self.max_health = stats.get_stat("max_health")
	self.current_health = stats.get_stat("current_health")
	self.current_health.set_value(max_health.get_value())
	self.current_health.value_changed.connect(_on_current_health_value_changed)
	pass

func _on_current_health_value_changed(current_health_stat : Stat):
	if current_health_stat.get_value() <= 0:
		health_depleted.emit()
	pass

func add_health(value : float):
	current_health.add(value)
	evaluate_health()
	pass

func decrease_health(value : float):
	current_health.add(-value)
	evaluate_health()

func evaluate_health():
	if current_health.get_derived_value() <= 0:
		health_depleted.emit()


func get_health() -> float:
	return current_health.get_derived_value()
