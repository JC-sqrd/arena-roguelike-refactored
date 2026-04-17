class_name WaveTimeLabel extends RichTextLabel

func _ready() -> void:
	visible = false
	EventServer.cuurrent_wave_started.connect(_on_wave_started)
	EventServer.current_wave_ended.connect(_on_wave_ended)
	EventServer.current_wave_time.connect(_on_current_wave_time_tick)
	pass

func _on_wave_started():
	visible = true
	pass

func _on_current_wave_time_tick(time : float):
	text = str(int(time))
	pass

func _on_wave_ended():
	visible = false
	pass
