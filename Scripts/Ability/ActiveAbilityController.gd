class_name ActiveAbilityController extends AbilityController

enum StartCooldown {START, EXECUTE, END}
@export var cooldown_timer : CooldownTimer = CooldownTimer.new()
@export var start_cooldown_on : StartCooldown = StartCooldown.START
var active : bool = false
var caster : Entity

var effects : Array[Effect]
signal ability_finished(abiltiy : ActiveAbilityController)

signal ability_to_start()
signal ability_started()
signal ability_to_execute()
signal ability_executed()
signal ability_to_end()
signal ability_ended()

func initialize(caster : Entity):
	self.caster = caster
	active = true
	controller_context = generate_controller_context()
	
	if start_cooldown_on == StartCooldown.START:
		ability_started.connect(_cooldown_start)
		pass
	elif start_cooldown_on == StartCooldown.EXECUTE:
		ability_executed.connect(_cooldown_start)
		pass
	elif start_cooldown_on == StartCooldown.END:
		ability_ended.connect(_cooldown_start)
		pass
	
	_on_initialized()
	pass

func _on_initialized():
	pass

func start_ability():
	if cooldown_timer.active:
		return
	ability_to_start.emit()
	_on_start()
	ability_started.emit()
	pass

func _on_start():
	pass

func execute():
	pass

func _on_execute():
	
	pass

func end():
	ability_to_end.emit()
	_on_end()
	ability_ended.emit()
	pass

func _on_end():
	pass

func generate_effects_from_templates(templates : Array[EffectTemplate], context : Dictionary[StringName, Variant]) -> Array[Effect]:
	var effects : Array[Effect]
	for template in templates:
		effects.append(template.build_effect(context))
		pass
	return effects

func generate_controller_context() -> Dictionary[StringName, Variant]:
	var context : Dictionary[StringName, Variant] = {}
	context["source"] = caster
	context["caster"] = caster
	context["caster_stats"] = caster.stats
	context["ability_id"] = ability_id
	context["controller"] = self
	return context

func _cooldown_start():
	cooldown_timer.start()
	pass
