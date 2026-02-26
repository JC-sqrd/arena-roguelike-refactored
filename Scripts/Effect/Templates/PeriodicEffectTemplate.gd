class_name PeriodicEffectTemplate extends EffectTemplate

@export var flat_modifiers : Array[FlatStatModifierTemplate]
@export var mult_modifiers : Array[MultiplierStatModifierTemplate]
@export var override_modifiers : Array[OverrideStatModifierTemplate]

func build_effect(context : Dictionary[StringName, Variant]) -> Effect:
	var modifier_templates : = flat_modifiers + mult_modifiers + override_modifiers
	var modifiers : Array[StatModifier]
	for template : StatModifierTemplate in modifier_templates:
		modifiers.append(template.build_modifier(context))
	var effect : PeriodicEffect = PeriodicEffect.new(modifiers)
	effect.effect_context = context
	effect.effect_events = effect_event_templates
	return 
