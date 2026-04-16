extends WeaponUpgradeNode

var _old_weapon_input : WeaponControllerInputStrategy
var charge_input : ChargeWeaponInput
@export var bonus_knockback : float = 500
var _final_bonus_knockback : float = 0
var knockback_magnitude_adder : ValueAdder

func apply_upgrade():
	_old_weapon_input = upgrade_tree.weapon_controller.weapon_input
	charge_input = ChargeWeaponInput.new()
	charge_input.initialize(upgrade_tree.weapon_controller)
	upgrade_tree.weapon_controller.weapon_input = charge_input
	upgrade_tree.weapon_controller.weapon_to_hit.connect(_on_weapon_to_hit)
	pass

func remove_upgrade():
	upgrade_tree.weapon_controller.weapon_input = _old_weapon_input
	pass


func _on_weapon_to_hit(hit : RID, effects : Array[Effect], context : Dictionary[StringName, Variant]):
	for effect in effects:
		if effect.effect_id == "damage_effect":
			for event_template in effect.effect_events:
				if event_template.get_effect_event_template_id() == "knockback_effect_event":
					_final_bonus_knockback = bonus_knockback
					knockback_magnitude_adder = ValueAdder.new()
					knockback_magnitude_adder.value = _final_bonus_knockback * charge_input.charge_ratio
					(event_template as KnockbackEffectEventTemplate).magnitude.adders.append(knockback_magnitude_adder)
					pass
				pass
			#if effect.mutator != null:
				#effect.mutator.value_provider.multipliers.append(damage_multiplier)
				#print("DAMAGE MULTIPLIER APPLIED")
			#if effect.modifier != null:
				#effect.modifier.value_provider.multipliers.append(damage_multiplier)
			pass
	pass
