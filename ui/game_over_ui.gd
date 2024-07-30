extends CanvasLayer
class_name GameOverUi

@onready var time_label = %TimeLabel
@onready var monster_label = %MonsterLabel

@export var restart_delay : float = 5.0
var time_survived : String
var restart_cooldown : float

func _ready():
	time_label.text = GameManager.time_elapsed_string
	monster_label.text = str(GameManager.monster_defeated)
	restart_cooldown = restart_delay
	
func _process(delta):
	restart_cooldown -= delta
	if restart_cooldown <= 0:
		restart_game()
		
func restart_game() -> void:
	GameManager.reset()
	get_tree().reload_current_scene()
	print("Restart game!")
	pass
	
	
	 
