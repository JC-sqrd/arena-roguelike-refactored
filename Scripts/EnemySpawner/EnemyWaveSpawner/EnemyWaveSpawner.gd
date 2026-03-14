class_name EnemyWaveSpawner extends Node2D

@export var interactable : Interactable
@export var wave_director : EnemyWaveDirector
@export var initial_wave : EnemyWaveData
@export var enemy_waves : Array[EnemyWaveData]

var current_wave : EnemyWaveData

func _ready() -> void:
	interactable.interacted.connect(_on_interacted)
	current_wave = initial_wave
	wave_director.wave_end.connect(_on_wave_end)
	pass

func _on_interacted():
	wave_director.start_wave(current_wave)
	interactable.enabled = false
	pass

func _on_wave_end():
	if current_wave.next_wave != null:
		current_wave = current_wave.next_wave
	interactable.enabled = true
	pass
