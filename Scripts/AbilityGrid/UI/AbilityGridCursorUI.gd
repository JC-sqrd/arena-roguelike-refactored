class_name AbilityGridCursorUI extends CursorUI

@onready var spark_particles: GPUParticles2D = %SparkParticles
@onready var circle_particle: GPUParticles2D = %CircleParticle
@onready var spark_particles_2: GPUParticles2D = %SparkParticles2

func emit_upgrade_particles():
	spark_particles.restart()
	circle_particle.restart()
	spark_particles_2.restart()
	circle_particle.emitting = true
	spark_particles.emitting = true
	spark_particles_2.emitting = true
	pass
