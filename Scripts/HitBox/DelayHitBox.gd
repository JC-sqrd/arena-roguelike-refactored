class_name DelayHitbox extends HitBox

@export var free_at : float = 1
@export var delay : float = 1


func _ready() -> void:
	get_tree().create_timer(free_at).timeout.connect(remove_hitbox)
	await get_tree().create_timer(delay).timeout
	
	
	query_hitbox()
	#for hit in area_hits:
		#for effect in effects:
			#EffectServer.receive_effect(hit.get_rid(), effect, context)
	pass

func remove_hitbox():
	queue_free()
	pass
