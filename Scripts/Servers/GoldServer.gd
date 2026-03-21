extends Node

var current_gold : float = 0

signal gold_added(amount_added : float)
signal gold_subtracted(amount_subtracted : float)

func add_gold(amount : float):
	current_gold += amount
	gold_added.emit(amount)
	pass

func subtract_gold(amount : float):
	current_gold -= amount
	gold_subtracted.emit(amount)
	pass
