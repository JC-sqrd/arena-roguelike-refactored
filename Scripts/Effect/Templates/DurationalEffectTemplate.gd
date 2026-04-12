class_name DurationalEffectTemplate extends EffectTemplate

@export var effect_id : StringName = "durational_effect"
@export var stackable : bool = false
@export var modifier : StatModifierTemplate
#@export var flat_modifiers : Array[FlatStatModifierTemplate]
#@export var mult_modifiers : Array[MultiplierStatModifierTemplate]
#@export var override_modifiers : Array[OverrideStatModifierTemplate]

func build_effect(context : Dictionary[StringName, Variant]) -> Effect:
	#var modifier_templates : = flat_modifiers + mult_modifiers + override_modifiers
	#var modifiers : Array[StatModifier]
	#for template : StatModifierTemplate in modifier_templates:
	#	modifiers.append(template.build_modifier(context))
	var effect : DurationalEffect = DurationalEffect.new(modifier.build_modifier(context))
	effect.stackable = stackable
	effect.effect_id = effect_id
	effect.effect_context = context
	for effect_event_template in effect_event_templates:
		effect.effect_events.append(effect_event_template.duplicate_effect_event_template(true))
	return effect
