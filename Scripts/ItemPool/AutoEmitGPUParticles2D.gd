class_name AutoEmitGPUParticles2D extends GPUParticles2D

@export var delay_timer : Timer

func _ready() -> void:
	delay_timer.start()
	await delay_timer.timeout
	emitting = true
	pass
