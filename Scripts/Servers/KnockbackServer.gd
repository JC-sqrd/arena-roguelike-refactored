extends Node

var active_knockbacks : Dictionary[int, KnockbackInstance]

class KnockbackInstance:
	var target : KnockbackTarget
	var force : Vector2
	var decay : float = 0
	var threshold : float = 0
	pass


func apply_knockback(target : KnockbackTarget, force_vector : Vector2, decay : float = 0.8, threshold : float = 1):
	if target == null:
		return
	
	var id : int = target.get_instance_id()
	if active_knockbacks.has(id):
		active_knockbacks[id].force += force_vector
		pass
	else:
		var knockback_instance : KnockbackInstance = KnockbackInstance.new()
		knockback_instance.target = target
		knockback_instance.decay = decay
		knockback_instance.threshold = threshold
		knockback_instance.force = force_vector
		active_knockbacks[id] = knockback_instance
	pass

func _physics_process(delta: float) -> void:
	if active_knockbacks.is_empty():
		return
	
	var to_remove = []
	
	for id in active_knockbacks:
		var instance : KnockbackInstance = active_knockbacks[id]
		var target : KnockbackTarget = instance.target
		
		if !target.is_target_valid():
			to_remove.append(id)
			continue
		
		#Apply knockback
		target.apply_knockback(instance.force * delta)
		
		#Apply knockback decay
		instance.force *= instance.decay
		
		if instance.force.length_squared() <= instance.threshold:
			instance.force = Vector2.ZERO
			to_remove.append(id)
		pass
	
	for id in to_remove:
		active_knockbacks.erase(id)
	pass
