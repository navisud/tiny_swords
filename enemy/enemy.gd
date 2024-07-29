class_name Enemy
extends CharacterBody2D

@export var health : int = 5
@export var death_prefab : PackedScene
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
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	queue_free()
