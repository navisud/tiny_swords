extends CharacterBody2D

@onready var sprite_player = $Sprite_Player
@onready var animation_player : AnimationPlayer = $AnimationPlayer

@export var speed : float = 3
@export_range(0,1) var smooth : float = 0.3 

var is_running: bool = false
var is_attacking: bool = false
var attack_cooldown : float = 0.0

func _process(delta: float) -> void:
	#Atualizar temporizador do ataque
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0:
			is_attacking = false
	
func _physics_process(delta: float) -> void:
	# Captura os movimentos AWSD setas controle etc / Project Settings > InputMap
	var input_vector = Input.get_vector("move_left","move_right", "move_up", "move_down")
	# Modificar a velocidade
	var target_velocity = input_vector * speed * 100.0
	if is_attacking:
		target_velocity *= 0.25
	# lerp suaviza o movimento
	velocity = lerp(velocity, target_velocity, smooth)
	move_and_slide() # Move o personagem com base na velocidade
	
	if not is_attacking:
		is_running = not input_vector.is_zero_approx() # Retorna verdadeiro se o vetor for 0
		if is_running:
			animation_player.play("run")
		else:
			animation_player.play("idle")
	
	#  flip eixo x
	if input_vector.x > 0:
		sprite_player.flip_h = false
	elif input_vector.x < 0:
		sprite_player.flip_h = true
	
	# attack	
	var attack_pressed: bool = Input.is_action_pressed("attack")
	if attack_pressed:
		attack()
	
	var rand : int
	rand = randi_range(0,1)
	if input_vector.y > 0:
		if attack_pressed:
			if rand == 0:
				animation_player.play("attack_down_1")
				attack_cooldown = 0.6
			else:
				animation_player.play("attack_down_2")
				attack_cooldown = 0.6
	
	if input_vector.y < 0:
		if attack_pressed:
			if rand == 0:
				animation_player.play("attack_up_1")
				attack_cooldown = 0.6
			else:
				animation_player.play("attack_up_2")
				attack_cooldown = 0.6
	
func attack() -> void:
	if is_attacking:
		return
# Randomiza o ataque
	var rand_attack : int = randi_range(0, 1)
	if rand_attack == 0:
		animation_player.play("attack_side_up")
	else:
		animation_player.play("attack_side_down")
	
	is_attacking = true
	attack_cooldown = 0.6
	pass
	
