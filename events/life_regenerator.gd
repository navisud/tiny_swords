extends Node2D

@export var regenerate_amount : int = 10

@onready var area2d : Area2D = $Area2D

func _ready():
	area2d.body_entered.connect(on_body_entered)
	
	
func on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var player : Player = body 
		player.heal(regenerate_amount)
	queue_free()
