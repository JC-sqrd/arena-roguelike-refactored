class_name DelayHitbox extends HitBox

@export var free_timer : Timer
@export var delay_timer : Timer


signal hits_queried(hits : Array[RID]) 

signal to_be_freed()

func _ready() -> void:
	free_timer.timeout.connect(remove_hitbox)
	free_timer.start()
	delay_timer.start()
	await delay_timer.timeout
	
	
	hits_queried.emit(query_hits()) 
	#for hit in area_hits:
		#for effect in effects:
			#EffectServer.receive_effect(hit.get_rid(), effect, context)
	pass

func remove_hitbox():
	to_be_freed.emit()
	queue_free()
	pass
