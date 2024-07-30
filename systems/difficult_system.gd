extends Node

@export var spawn_rate_per_minute : float = 30
@export var mob_spawner : MobSpawner
@export var wave_duration : float = 20
@export var initial_spawn_rate : float = 60
@export var break_intensity : float = 0.5

var time : float = 0.0

func _process(delta):
	if GameManager.is_game_over: return
	
	time += delta
	# Linear difficulty green line
	var spawn_rate = initial_spawn_rate + spawn_rate_per_minute * (time / 60)
	# Waves system pink line sin
	var sin_wave = sin((time * TAU) / wave_duration)
	var wave_factor = remap(sin_wave, -1.0, 1.0, break_intensity, 1)
	spawn_rate *= wave_factor
	# aplly difficulty
	mob_spawner.mobs_per_minute = initial_spawn_rate
	
	
	
