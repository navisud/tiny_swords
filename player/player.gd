extends CharacterBody2D

@onready var sprite_player = $Sprite_Player
@onready var animation_player : AnimationPlayer = $AnimationPlayer

@export var speed : float = 3
@export_range(0,1) var smooth : float = 0.3 

var rand : int = 0
var is_running: bool = false
var is_attacking: bool = false
var attack_cooldown : float = 0.0
var input_vector : Vector2 = Vector2(0,0)


func _process(delta: float) -> void:
# _process runs every frame per second
	update_attack_cooldown(delta)
	read_input()
	play_run_idle()
	flip_sprite()

func _physics_process(delta: float) -> void:
# modify player speed
	var target_velocity = input_vector * speed * 100.0
	if is_attacking:
		target_velocity *= 0.25
# lerp smooths movement
	velocity = lerp(velocity, target_velocity, smooth)
	move_and_slide()

func attack() -> void:
	if is_attacking:
		return
# attack left right
	var rand_attack : int = randi_range(0, 1)
	if rand_attack == 0:
		animation_player.play("attack_side_up")
	else:
		animation_player.play("attack_side_down")
	
# attack up and down
	rand = randi_range(0,1)
	if input_vector.y > 0:
		if rand == 0:
			animation_player.play("attack_down_1")
		else:
			animation_player.play("attack_down_2")
	
	if input_vector.y < 0:
		if rand == 0:
			animation_player.play("attack_up_1")
		else:
			animation_player.play("attack_up_2")
	
	is_attacking = true
	attack_cooldown = 0.6
	
func read_input() -> void:
# capture the keys awsd and video game controller / Project Settings > InputMap
	input_vector = Input.get_vector("move_left","move_right", "move_up", "move_down")
	
# attack key listen
	var attack_pressed: bool = Input.is_action_pressed("attack")
	if attack_pressed:
		attack()
	
# erase deadzone axis x/y (vg controller)
	var deadzone = 0.15
	if abs(input_vector.x) < 0.15:
		input_vector.x = 0.0
	if abs(input_vector.y) < 0.15:
		input_vector.y = 0.0

func play_run_idle() -> void:
	# Roda animação
	if not is_attacking:
		is_running = not input_vector.is_zero_approx() # Retorna verdadeiro se o vetor for 0
		if is_running:
			animation_player.play("run")
		else:
			animation_player.play("idle")

func flip_sprite() -> void:
# flip player axis x
	if input_vector.x > 0:
		sprite_player.flip_h = false
	elif input_vector.x < 0:
		sprite_player.flip_h = true

func update_attack_cooldown(delta: float) -> void:
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0:
			is_attacking = false
