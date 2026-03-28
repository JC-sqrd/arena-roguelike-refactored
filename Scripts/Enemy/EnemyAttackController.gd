class_name EnemyAttackController extends Node

@export var attack_timer : Timer

@export var effects_template : Array[EffectTemplate]

var can_attack : bool = true
var query_attack : bool = false

var _attacker_stats : Stats
var _attack_speed_stat : Stat
var _context : Dictionary[StringName, Variant]
var _effects : Array[Effect]
var _target_rid : RID

var _initialized : bool = false

var hit_logs : Array[RID]


func initialize(attacker_stats : Stats):
	self._attacker_stats = attacker_stats
	_context = generate_effect_context(attacker_stats)
	for template in effects_template:
		_effects.append(template.build_effect(_context))
	
	_initialized = true
	pass

func activate (target_rid : RID):
	if !_initialized:
		printerr("Attack controller needs to be initialized before being activated.")
		return
	
	self._target_rid = target_rid
	
	apply_effects()
	
	_attack_speed_stat = _attacker_stats.get_stat("attack_speed")
	attack_timer.start( 1 / _attack_speed_stat.get_value())
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	pass


func deactivate():
	attack_timer.stop()
	pass

func _on_attack_timer_timeout():
	apply_effects()
	pass

func apply_effects():
	for effect in _effects:
		EffectServer.receive_effect(_target_rid, effect, _context)
		pass
	pass

func generate_effect_context(attacker_stats : Stats) -> Dictionary[StringName, Variant]:
	var context : Dictionary[StringName, Variant]
	context["attacker_stats"] = attacker_stats
	return context

func _exit_tree() -> void:
	for effect in _effects:
		effect.cleanup()
	_effects.clear()
	hit_logs.clear()
	_attacker_stats = null
	_attack_speed_stat = null
	pass
