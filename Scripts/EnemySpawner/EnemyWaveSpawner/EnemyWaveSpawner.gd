class_name EnemyWaveSpawner extends Node2D

@export var interactable : Interactable
@export var wave_director : EnemyWaveDirector
@export var initial_wave : EnemyWaveData

var current_wave : EnemyWaveData

func _ready() -> void:
	interactable.interacted.connect(_on_interacted)
	current_wave = initial_wave
	pass

func _on_interacted():
	wave_director.start_wave(current_wave)
	pass
