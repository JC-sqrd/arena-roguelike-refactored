extends Control

@onready var gold_label: Label = %GoldLabel


func _ready() -> void:
	GoldServer.gold_added.connect(_on_gold_added)
	GoldServer.gold_subtracted.connect(_on_gold_subtracted)
	gold_label.text = "GOLD: " + str(GoldServer.current_gold)
	pass

func _on_gold_added(added : float):
	gold_label.text = "GOLD: " + str(GoldServer.current_gold)
	pass

func _on_gold_subtracted(subtracted : float):
	gold_label.text = "GOLD: " + str(GoldServer.current_gold)
	pass
