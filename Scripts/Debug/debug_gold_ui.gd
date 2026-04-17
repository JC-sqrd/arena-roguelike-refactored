extends Control

@onready var gold_label: Label = %GoldLabel
@onready var active_entities_label: Label = %ActiveEntitiesLabel


func _ready() -> void:
	CurrencyServer.gold_added.connect(_on_gold_added)
	CurrencyServer.gold_subtracted.connect(_on_gold_subtracted)
	gold_label.text = "GOLD: " + str(CurrencyServer.current_gold)
	pass

func _process(delta: float) -> void:
	active_entities_label.text = str(EntityServer.active_entities.size())

func _on_gold_added(added : float):
	gold_label.text = "GOLD: " + str(CurrencyServer.current_gold)
	pass

func _on_gold_subtracted(subtracted : float):
	gold_label.text = "GOLD: " + str(CurrencyServer.current_gold)
	pass
