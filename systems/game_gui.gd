extends CanvasLayer

@onready var timer_label : Label = %Timer
@onready var meat_label : Label = %Meat_Label

var meat_counter : int = 0

func _ready():
	GameManager.player.meat_collected.connect(on_meat_collected)

func _process(delta: float):
	timer_label.text = GameManager.time_elapsed_string
	
func on_meat_collected(regeneration_value: int) -> void:
	meat_counter += 1
	meat_label.text = str(meat_counter)
	
	
