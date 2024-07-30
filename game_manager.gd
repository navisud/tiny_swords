extends Node

signal game_over

var player : Player
var player_position : Vector2
var is_game_over : bool = false
var monster_defeated : int
var time_elapsed: float
var time_elapsed_string: String

func _process(delta: float):
	time_elapsed += delta
# arrendonda pra baixo  floori
	var time_elapsed_in_seconds : int = floori(time_elapsed)
	var seconds : int = time_elapsed_in_seconds % 60
	var minutes : int = time_elapsed_in_seconds / 60
	
	time_elapsed_string = "%02d:%02d" % [minutes, seconds]

func end_game():
	if is_game_over: return
	is_game_over = true
	game_over.emit()

func reset():
	player = null
	player_position = Vector2.ZERO
	is_game_over = false
	monster_defeated = 0
	time_elapsed = 0
	time_elapsed_string = "" 
	for connections in game_over.get_connections():
		game_over.disconnect(connections.callable)
