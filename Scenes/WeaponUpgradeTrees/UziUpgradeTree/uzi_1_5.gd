extends WeaponUpgradeNode

@export var hit_threshold : int = 10
@export var jump_delay : float = 0.1
@export var effect_template : EffectTemplate
@export var area_template : AreaTemplate
var _hit_counter : int = 0

var active_lightnings : Dictionary[Line2D, Array]
var to_free : Array[Line2D]



const UZI_LIGHTNING = preload("uid://d1axywy6nx0hh")

func apply_upgrade():
	EventServer.weapon_hit.connect(_on_weapon_hit)
	pass

func remove_upgrade():
	EventServer.weapon_hit.disconnect(_on_weapon_hit)
	pass

func _physics_process(delta: float) -> void:
	if !to_free.is_empty():
		for i in to_free:
			if active_lightnings.has(i):
				active_lightnings.erase(i)
				i.queue_free()
			pass
		to_free.clear()
	
	if active_lightnings.is_empty():
		return
	
	for lightning in active_lightnings:
		
		var data : Array[Variant] = active_lightnings[lightning]
		data[3] -= delta
		var lightning_jump_delay : float = data[3]
		
		if lightning_jump_delay <= 0:
			var area : Area = data[1]
			var target_id : RID = data[2]
			if EntityServer.active_entities.has(target_id):
				var target : Entity = EntityServer.active_entities[target_id]
				lightning.global_position = target.global_position
				apply_effect_to_target(target_id)
				area.set_global_position(target.global_position)
				var new_target_id : RID
				var near_targets : Array[RID] = area.query_area()
				if !near_targets.is_empty():
					new_target_id = near_targets[0]
					var new_target : Entity = EntityServer.active_entities[new_target_id]
					data[2] = new_target_id
					#lightning.clear_points()
					#lightning.add_point(target.global_position)
					#lightning.add_point(new_target.global_position)
					data[0] -= 1
					var jump_count : int = data[0]
					if jump_count <= 0:
						to_free.append(lightning)
						area.free_area()
						pass
				else:
					to_free.append(lightning)
			else:
				to_free.append(lightning)
				pass
			data[3] = jump_delay
		pass
	pass

func apply_effect_to_target(target_id : RID):
	var context : Dictionary[StringName, Variant] = upgrade_tree.weapon_controller.generate_controller_context()
	EffectServer.receive_effect(target_id, effect_template.build_effect(context), context)
	pass

func _on_weapon_hit(hit : RID, weapon_effects : Array[Effect], context : Dictionary[StringName, Variant]):
	

	
	if context.has("weapon_id"):
		if context.weapon_id == upgrade_tree.weapon_controller.weapon_id:
			_hit_counter += 1
	
	if _hit_counter >= hit_threshold:
		var lightning : Line2D = UZI_LIGHTNING.instantiate() as Line2D
		var jump_count : int = 10
		var jump_delay : float = jump_delay
		var area : Area = area_template.build_area()
		var target : Entity = EntityServer.active_entities[hit]
		area.set_global_position(target.global_position)
		var targets : Array[RID] = area.query_area()
		if !targets.is_empty():
			var target_id : RID = targets[0]
			var new_target : Entity = EntityServer.active_entities[target_id]
			var data : Array[Variant] = [jump_count, area, target_id, jump_delay]
			lightning.global_position = target.global_position
			#lightning.add_point(target.global_position)
			#lightning.add_point(new_target.global_position)
			get_tree().root.add_child(lightning)
			
			active_lightnings[lightning] = data
			_hit_counter = 0
		pass
	pass
