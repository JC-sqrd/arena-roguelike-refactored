class_name SpawnHitBox extends RefCounted



static func spawn_hit_box_scene(hitbox_scene : PackedScene, parent_node : Node2D, spawn_position : Vector2, effects : Array[Effect], context : Dictionary[StringName, Variant], coll_layer : int = 0, coll_mask : int = 0):
	var hitbox : HitBox = hitbox_scene.instantiate()
	hitbox.global_position = spawn_position
	hitbox.effects = effects
	hitbox.context = context
	parent_node.add_child(hitbox)
	pass
