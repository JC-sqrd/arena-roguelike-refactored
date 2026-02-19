class_name EquipmentManager extends Node

@export var equipment_inventory : Array[Equipment]
@export var weapon_hold_pos : Node2D

@export var equipped_weapon : Weapon

@export_category("Main Weapon Slot")
@export var main_weapon_slot : EquipSlot
@export var attack_input_listener : AttackInputListener

var stats : Stats

func initialize(stats : Stats):
	self.stats = stats
	
	attack_input_listener.initialize(stats)
	
	equip_weapon(main_weapon_slot.equipped_equipment)
	pass

func equip_weapon(equipment : Weapon):
	var equip_context : EquipContext = EquipContext.new()
	
	equip_context.wielder_stats = stats
	equip_context.hold_anchor = weapon_hold_pos
	
	main_weapon_slot.equip(equipment, equip_context)
	pass
