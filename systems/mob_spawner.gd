class_name MobSpawner
extends Node2D

@onready var path_follow_2d : PathFollow2D = %PathFollow2D

@export var creatures : Array[PackedScene]
var mobs_per_minute : float = 60.0

var cooldown : float = 0.0

func _process(delta: float):
	if GameManager.is_game_over: return
# cooldown timer
	cooldown -= delta
	if cooldown > 0: return
# frequency monster p minute
	var interval = 60.0 / mobs_per_minute
	cooldown = interval
# create rand instance
	var point = get_point()
	var index = randi_range(0, creatures.size() -1)
	var creature_scene = creatures[index]
	var creature = creature_scene.instantiate() # create scene
	creature.global_position = point # mob position rand
	get_parent().add_child(creature) # attach a child element to the parent
# check valid point
	var parameters = PhysicsPointQueryParameters2D.new()
	var world_state = get_world_2d().direct_space_state
	var result : Array = world_state.intersect_point(parameters, 1)
	if not result.is_empty(): return

func get_point() -> Vector2:
	path_follow_2d.progress_ratio = randf()
	return path_follow_2d.global_position
