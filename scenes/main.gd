extends Node2D

@export var spawn_interval: float = 2.0
@export var spawn_distance: float = 600.0

var enemy_scenes = []
var player: Node2D
var spawn_timer: Timer

func _ready():
	# Load enemy scenes
	enemy_scenes.append(preload("res://scenes/Jellyfish.tscn"))
	enemy_scenes.append(preload("res://scenes/Octopus.tscn"))
	enemy_scenes.append(preload("res://scenes/Shark.tscn"))
	
	player = get_tree().get_first_node_in_group("player")
	
	# Setup timer
	spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_interval
	spawn_timer.timeout.connect(_spawn_enemy)
	add_child(spawn_timer)
	spawn_timer.start()

func _spawn_enemy():
	if not player:
		return
	
	# Pick random enemy
	var enemy_scene = enemy_scenes[randi() % enemy_scenes.size()]
	var enemy = enemy_scene.instantiate()
	
	# Spawn at random position around player
	var angle = randf() * TAU
	var spawn_pos = player.global_position + Vector2.from_angle(angle) * spawn_distance
	enemy.global_position = spawn_pos
	
	get_parent().add_child(enemy)
