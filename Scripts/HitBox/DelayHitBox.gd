class_name DelayHitbox extends HitBox


@export var free_delay : float = 1
var area_hits : Array[Area2D]

func _ready() -> void:
	
	await get_tree().create_timer(free_delay).timeout
	
	area_hits = get_overlapping_areas()
	
	for hit in area_hits:
		for effect in effects:
			EffectServer.receive_effect(hit.get_rid(), effect, context)
	
	queue_free()
	pass
