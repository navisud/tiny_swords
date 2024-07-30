class_name Enemy
extends CharacterBody2D

@export var health : int = 5
@export var death_prefab : PackedScene

@export_category("Drops")
@export var drop_chance: float = 0.1
@export var drop_items : Array[PackedScene]
@export var drop_chances : Array[float]

@onready var dmg_digit_marker = $Damage_Digit_Marker

var dmg_digit_prefab : PackedScene

func _ready():
	dmg_digit_prefab = preload("res://events/dmg_digit.tscn")

func damage(amount: int) -> void:
	health -= amount
	print("Inimigo recebeu ", amount ," de dano. A vida total  de ", health)

# damage digit
	var dmg_dgt = dmg_digit_prefab.instantiate()
	dmg_dgt.value = amount
	
	if dmg_digit_marker:
		dmg_dgt.global_position = dmg_digit_marker.global_position
	else:
		dmg_dgt.global_position = global_position
	get_parent().add_child(dmg_dgt)
# blink node
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)

	if health <= 0:
		die()

func die() -> void:
	GameManager.monster_defeated += 1
# skull
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
# drop item
	if randf() <= drop_chance:
		drop_item()
# delete node
	queue_free()

func drop_item() ->  void:
	var drop = get_random_drop_item().instantiate()
	drop.position = position
	get_parent().add_child(drop)

func get_random_drop_item() -> PackedScene:
	# Listas com 1 item
	if drop_items.size() == 1:
		return drop_items[0]
# calcular chance max
	var max_chance: float = 0.0
	for drop_chance in drop_chances:
		max_chance += drop_chance
	# jogar dado
	var random_value = randf() * max_chance
	# girar roleta
	var needle: float = 0.0
	for i in drop_items.size():
		var drop_item = drop_items[i]
		var drop_chance = drop_chances[i] if i < drop_chances.size() else 1
		if random_value <= drop_chance + needle:
			return drop_item
		needle += drop_chance
		
	return drop_items[0]

