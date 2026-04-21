class_name AbilityGridCursorUI extends CursorUI

@onready var upgrade_particles: GPUParticles2D = $UpgradeParticles

func emit_upgrade_particles():
	upgrade_particles.restart()
	upgrade_particles.emitting = true
	pass
