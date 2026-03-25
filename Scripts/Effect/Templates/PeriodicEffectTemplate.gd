class_name PeriodicEffectTemplate extends EffectTemplate

@export var effect_id : StringName = "periodic_effect"
@export var stat_modifier : StatModifierTemplate


func build_effect(context : Dictionary[StringName, Variant]) -> Effect:
	#var modifier_templates : = flat_modifiers + mult_modifiers + override_modifiers
	#var modifiers : Array[StatModifier]
	#for template : StatModifierTemplate in modifier_templates:
	#	modifiers.append(template.build_modifier(context))
	var effect : PeriodicEffect = PeriodicEffect.new(stat_modifier.build_modifier(context))
	effect.effect_id = effect_id
	effect.effect_context = context
	for effect_event_template in effect_event_templates:
		effect.effect_events.append(effect_event_template.duplicate_effect_event_template(true))
	return 
