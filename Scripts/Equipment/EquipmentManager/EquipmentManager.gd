class_name EquipmentManager extends Node

@export var equipment_inventory : Array[Item]
@export var weapon_hold_pos : Node2D

var equipped_weapon : Weapon

@export_category("Main Weapon Slot")
@export var main_weapon_slot : EquipSlot
@export var attack_input_listener : AttackInputListener

var wielder : Entity
var stats : Stats

signal weapon_equipped(weapon : Weapon)
signal weapon_unequipped(weapon : Weapon)

func initialize(wielder : Entity):
	self.stats = wielder.stats
	self.wielder = wielder
	
	attack_input_listener.initialize(stats)
	
	equip_weapon(main_weapon_slot.equipped_equipment)
	pass

func equip_weapon(equipment : Weapon):
	var equip_context : EquipContext = EquipContext.new()
	
	equip_context.wielder_stats = stats
	equip_context.wielder = wielder
	equip_context.hold_anchor = weapon_hold_pos
	
	equipped_weapon = equipment
	main_weapon_slot.equip(equipment, equip_context)
	weapon_equipped.emit(equipment)
	pass

func unequip_weapon():
	var weapon : Weapon = main_weapon_slot.unequip()
	equipped_weapon = null
	weapon_unequipped.emit(weapon)
	pass
