extends Node

@export var speed : float = 0.7

var enemy : Enemy
var sprite_enemy : AnimatedSprite2D

func _ready():
	enemy = get_parent()
	sprite_enemy = enemy.get_node("AnimatedSprite2D")
	enemy.health
	
func _physics_process(delta: float) -> void:
	if GameManager.is_game_over: return
# calculate direction
	var player_position = GameManager.player_position
	var difference = player_position - enemy.position
	var input_vector = difference.normalized()
# movement
	enemy.velocity = input_vector * speed * 100
	enemy.move_and_slide()
# flip axis x
	if input_vector.x > 0:
		sprite_enemy.flip_h = false
	elif input_vector.x < 0:
		sprite_enemy.flip_h = true
	
