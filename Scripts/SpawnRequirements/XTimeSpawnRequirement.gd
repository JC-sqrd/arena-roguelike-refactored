class_name XTimeSpawnRequirement extends SpawnRequirement

@export var required_time : float = 0



func requirement_met(data : WaveData) -> bool:
	if data.current_wave_time <= required_time:
		return true
	return false
