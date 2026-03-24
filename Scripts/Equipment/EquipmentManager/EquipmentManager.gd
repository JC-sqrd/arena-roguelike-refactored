class_name EquipmentManager extends Node

@export var equipment_inventory : Array[Item]
@export var weapon_hold_pos : Node2D

var equipped_weapon : Weapon

@export_category("Main Weapon Slot")
@export var main_weapon_slot : EquipSlot
@export_category("Second Weapon Slot")
@export var second_weapon_slot : EquipSlot
@export var attack_input_listener : AttackInputListener

var wielder : Entity
var stats : Stats

var weapon_1_controller : WeaponController
var weapon_2_controller : WeaponController

var weapon_1_input_held : bool = false
var weapon_2_input_held : bool = false

signal weapon_equipped(weapon : Weapon)
signal weapon_unequipped(weapon : Weapon)

func initialize(wielder : Entity):
	self.stats = wielder.stats
	self.wielder = wielder
	
	attack_input_listener.initialize(stats)
	if main_weapon_slot != null and main_weapon_slot.equipped_equipment != null:
		equip_weapon(main_weapon_slot.equipped_equipment)
		weapon_1_controller = (main_weapon_slot.equipped_equipment as Weapon).get_active_controller()
	
	if second_weapon_slot != null and second_weapon_slot.equipped_equipment != null:
		equip_weapon(second_weapon_slot.equipped_equipment)
		weapon_2_controller = (second_weapon_slot.equipped_equipment as Weapon).get_active_controller()
		weapon_2_controller.visible = false
		pass
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

func _process(delta: float) -> void:
	if weapon_1_controller != null:
		weapon_1_controller.weapon_input.update(delta)
		pass
	if weapon_2_controller != null:
		weapon_2_controller.weapon_input.update(delta)
	
	

func _unhandled_input(event: InputEvent) -> void:
	process_input()
	#if _input_held:
	pass

func process_input():
	if Input.is_action_just_pressed("attack"):
		weapon_1_input_held = true
		weapon_1_controller.visible = true
		weapon_2_controller.visible = false
		if weapon_1_controller != null:
			weapon_1_controller.weapon_input.handle_input_pressed()
	
	if Input.is_action_just_released("attack"):
		weapon_1_input_held = false
		if weapon_1_controller != null:
			weapon_1_controller.weapon_input.handle_input_released()
		pass
	
	
	if Input.is_action_just_pressed("attack2"):
		weapon_2_input_held = true
		weapon_1_controller.visible = false
		weapon_2_controller.visible = true
		if weapon_2_controller != null:
			weapon_2_controller.weapon_input.handle_input_pressed()
	
	if Input.is_action_just_released("attack2"):
		weapon_2_input_held = false
		if weapon_2_controller != null:
			weapon_2_controller.weapon_input.handle_input_released()
			pass
	
	#if Input.is_action_pressed("attack"):
		#weapon_1_input_held = true
		#pass
	#
	#if Input.is_action_pressed("attack2"):
		#weapon_2_input_held = true
		#pass
	#
	#if Input.is_action_just_released("attack"):
		#weapon_1_input_held = false
		#pass
	#
	#if Input.is_action_just_released("attack2"):
		#weapon_2_input_held = false
		#pass
	
	#if weapon_1_input_held and !weapon_2_input_held:
		#if weapon_1_controller != null:
			#weapon_1_controller.start_attack()
		#pass
	#elif weapon_2_input_held and !weapon_1_input_held:
		#if weapon_2_controller != null:
			#weapon_2_controller.start_attack()
		#pass
	#elif weapon_1_input_held and weapon_2_input_held:
		#if weapon_1_controller != null:
			#weapon_1_controller.start_attack()
		#pass
	pass

func on_weapon_unequipped(weapon : Weapon):
	if weapon == main_weapon_slot.equipped_equipment:
		weapon_1_controller = null
		pass
	elif weapon == second_weapon_slot.equipped_equipment:
		weapon_2_controller = null
		pass
	pass
