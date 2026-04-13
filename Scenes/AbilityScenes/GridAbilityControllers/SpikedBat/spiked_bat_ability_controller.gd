extends GridAbilityController


@export var area_template : AreaTemplate
@export var effect_templates : Array[EffectTemplate]
@export_flags_2d_physics var collision_mask_layer : int

const SPIKED_BAT_HITBOX = preload("uid://sy60xpo0pa1x")

var hitbox : HitBox
var area : Area

var c_float_around_target : FloatAroundTarget

func _on_initialized():
	hitbox = SPIKED_BAT_HITBOX.instantiate() as HitBox
	for template in effect_templates:
		effects.append(template.build_effect(controller_context))
		pass
	
	area = area_template.build_area()
	area.owner = self
	get_tree().root.add_child(hitbox)
	#hitbox.effects = effects
	hitbox.collision_mask = collision_mask_layer
	hitbox.global_position = caster.global_position
	
	c_float_around_target = FloatAroundTarget.new(hitbox)
	pass


func _physics_process(delta: float) -> void:
	c_float_around_target.float_around_target(caster.global_position, delta)

func _exit_tree() -> void:
	hitbox.queue_free()
	pass
