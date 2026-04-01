class_name EntityDamageNumberSpawner extends Node

@export var label_settings : LabelSettings
@export var spawn_point : Node2D
@export var spawn_offsset : Vector2 

var _entity_id : RID
var entity : Entity

func initialize(entity_id : RID):
	entity = EntityServer.active_entities[entity_id]
	EventServer.damage_event.connect(_on_damage_event_occured)
	
	_entity_id = entity_id
	pass



func _on_damage_event_occured(damage_amount : float, target : Entity, source : Entity, context : Dictionary[StringName, Variant]):
	if target.entity_rid == _entity_id:
		spawn_label(damage_amount, context)
	pass

func spawn_label(damage_amount : float, context : Dictionary[StringName, Variant]):
	var new_label : Label = Label.new()
	new_label.text = str(damage_amount)
	new_label.label_settings = label_settings.duplicate()
	new_label.z_index = 1000
	new_label.pivot_offset_ratio = Vector2(0.5, 1.0)
	
	var label_material : CanvasItemMaterial = CanvasItemMaterial.new()
	label_material.light_mode = CanvasItemMaterial.LIGHT_MODE_UNSHADED
	new_label.material = label_material
	
	spawn_point.call_deferred("add_child", new_label)
	await new_label.resized
	new_label.position -= Vector2(new_label.size.x / 2.0, new_label.size.y)
	new_label.position += Vector2(randf_range(-5.0, 5.0), randf_range(-5.0, 5.0))
	
	
	var global_pos : Vector2 = entity.global_position
	var target_rise_pos : Vector2 = entity.global_position + Vector2(randf_range(-5.0, 5.0), randf_range(-22.0, -16.0))
	var tween_length : float = 5
	var label_tween : Tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	label_tween.tween_property(new_label, "global_position", target_rise_pos, tween_length)
	label_tween.parallel().tween_property(new_label, "scale", Vector2.ONE * 1.35, tween_length)
	label_tween.parallel().tween_property(new_label, "modulate:a", 0.0, tween_length).connect("finished", new_label.queue_free)
	pass

func get_component_name() -> StringName:
	return "entity_damage_number_spawner"

func _exit_tree() -> void:
	EventServer.damage_event.disconnect(_on_damage_event_occured)
	_entity_id = RID()
	entity = null
	label_settings = null
