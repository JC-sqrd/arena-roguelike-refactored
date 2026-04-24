extends WeaponUpgradeNode
@export var burst_attack_execute : ProjectileAttackExecute

var _original_burst_count : int 

func apply_upgrade():
	_original_burst_count = burst_attack_execute.burst_count
	burst_attack_execute.burst_count = 5
	pass

func remove_upgrade():
	burst_attack_execute.burst_count = _original_burst_count
	pass
