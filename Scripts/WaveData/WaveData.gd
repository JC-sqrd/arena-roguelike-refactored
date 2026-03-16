@abstract
class_name WaveData extends Resource

@export var wave_budget : float = 1000
@export var budget_gain : float = 100
@export var budget_gain_curve : Curve

var curr_budget : float = wave_budget

@export var wave_duration : float = 10
@export var next_wave : WaveData
var current_wave_time : float = 0
