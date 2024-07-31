extends Node2D

@onready var houses_ = $construction/houses_

func _process(delta):
	create_house()
	
func create_house() -> void:
	var houses = houses_.get_children()
	var red : Sprite2D = houses[0]
	var purple : Sprite2D = houses[1]
	var yellow : Sprite2D = houses[2]
	var blue : Sprite2D = houses[3]
	
	red.visible = false
	purple.visible = true
	yellow.visible = false
	blue.visible = false
	#print(houses)
	pass
