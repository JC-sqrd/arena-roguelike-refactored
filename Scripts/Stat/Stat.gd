class_name Stat extends RefCounted


#NOTE: Careful on referencing other RefCounted objects, make sure to use weakref() to prevent cyclic dependencies
var stat_id : StringName
var name : String
var value : float = 0
var bonus_value : float = 0
var multiplier : float = 1
var modifiers : Array[StatModifier]



var _is_dirty : bool = false
var _base : float = 0

signal value_changed(stat : Stat)

func _init(stat_id : StringName, stat_value : float, name : String = "Stat", bonus_value : float = 0, multiplier : float = 1):
	self.name = name
	self.stat_id = stat_id
	self.value = (stat_value + bonus_value) * multiplier
	self.bonus_value = bonus_value
	self.multiplier = multiplier
	self._base = stat_value
	pass

func add(value : float):
	self.value += value
	value_changed.emit(self)
	pass

func set_value(value : float):
	#Reset value
	self.value = (self.value / multiplier) - self.bonus_value
	
	#Set value
	self.value = value
	
	#Recalculate derived value
	self.value = (self.value + self.bonus_value) * multiplier
	value_changed.emit(self)
	pass

func add_modifier(stat_mofifier : StatModifier):
	modifiers.append(stat_mofifier)

func add_bonus_value(value : float):
	
	#Reset value
	self.value = (self.value / multiplier) - self.bonus_value
	
	#Add bonus value
	self.bonus_value += value
	
	#Recalculate derived value
	self.value = (self.value + self.bonus_value) * multiplier
	
	value_changed.emit(self)
	pass

func add_multiplier(multiplier : float):
	
	#Reset value
	value = (value / self.multiplier) - self.bonus_value
	
	
	#Add multiplier
	self.multiplier += multiplier
	
	#Recalculate derived value
	value = (value + self.bonus_value) * self.multiplier
	
	value_changed.emit(self)
	pass


func remove_modifier(stat_modifier : StatModifier):
	modifiers.erase(stat_modifier)

func get_value()-> float:
	return value

func get_base_value() -> float:
	return _base 

func set_base_balue(value : float):
	_base = value
