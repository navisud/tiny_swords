class_name Player
extends CharacterBody2D

@onready var sprite_player = $Sprite_Player
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var sword_area : Area2D = $SwordArea
@onready var hitbox_area : Area2D = $HitboxArea
@onready var health_bar : ProgressBar = $ProgressBar 

@export_category("Sword")
@export var sword_damage : int = 2

@export_category("Movement")
@export var speed : float = 3
@export_range(0,1) var smooth : float = 0.3 

@export_category("Life")
@export var health : int = 100
@export var max_health : int = 100
@export var death_prefab : PackedScene

@export_category("Ritual")
@export var ritual_damage : int = 2
@export var ritual_interval : float = 30
@export var ritual_scene : PackedScene 

var rand : int = 0
var is_running: bool = false
var is_attacking: bool = false
var attack_cooldown : float = 0.0
var hitbox_cooldown : float = 0.0
var ritual_cooldown  : float = 0.0
var input_vector : Vector2 = Vector2(0,0)

signal meat_collected(value: int)

func _ready():
	GameManager.player = self

func _process(delta: float) -> void:
# _process runs every frame per second
	update_attack_cooldown(delta)
	read_input()
	play_run_idle()

	if not is_attacking:
		flip_sprite()
	update_hitbox_detection(delta)

# ritual spell
	update_ritual(delta)
# update health bar	
	health_bar.max_value = max_health
	health_bar.value = health

# lock mc 
	if is_attacking:
		speed = 0
	else:
		speed = 3

# says player position for enemies
	GameManager.player_position = position

func _physics_process(delta: float) -> void:
# modify player speed
	var target_velocity = input_vector * speed * 100.0
	if is_attacking:
		target_velocity *= 0.25
# lerp smooths movement
	velocity = lerp(velocity, target_velocity, smooth)
	move_and_slide()

func update_ritual(delta: float) -> void:
	ritual_cooldown -= delta
	if ritual_cooldown > 0 : return
	ritual_cooldown = ritual_interval
# ritual scene create
	var ritual = ritual_scene.instantiate()	
	add_child(ritual)
	ritual.damage_amount = ritual_damage

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
	
func deal_damage_to_enemy() -> void:
	var bodies = sword_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy : Enemy = body
			# calculate enemy direction and view
			var direction_to_enemy = (enemy.position - position).normalized()
			var attack_direction: Vector2
			
			if sprite_player.flip_h:
				attack_direction = Vector2.LEFT
			else:
				attack_direction = Vector2.RIGHT
				
			if input_vector.y > 0:
				attack_direction = Vector2.UP
			elif input_vector.y < 0:
				attack_direction = Vector2.DOWN
				
			var dot_product = direction_to_enemy.dot(attack_direction)
			# enemy damage
			if dot_product >= 0.3:
				enemy.damage(sword_damage)
			
			if dot_product <= -0.1:
				enemy.damage(sword_damage)
			print("Dot: ", dot_product)
			
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

func update_hitbox_detection(delta: float) -> void:
# timer
	hitbox_cooldown -= delta
	if hitbox_cooldown > 0: return
	
# frequency
	hitbox_cooldown = 0.5

# detect enemies
	var bodies = hitbox_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy : Enemy = body
			var damage_amount = 1
			damage(damage_amount)

func damage(amount: int) -> void:
	if health <= 0: return
	
	health -= amount
	#print("Player recebeu ", amount ," de dano. A vida total  de ", health)

# blink node
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)

	if health <= 0:
		die()

func die() -> void:
	GameManager.end_game()
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
		print("Player morreu!")
	queue_free()

func heal(amount: int) -> int:
	health += amount
	if health > max_health:
		health = max_health
	print("Player recebeu cura de ", amount ,". A vida total  de ", health,"/",max_health)

# blink player when regenerate life
	modulate = Color.GREEN
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.5  )
	return health
	
