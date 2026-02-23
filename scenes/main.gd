extends Node2D

@export var spawn_interval: float = 2.0
@export var spawn_distance: float = 600.0

var enemy_scenes = []
var player: Node2D
var spawn_timer: Timer
var game_timer: float = 0.0
var game_over: bool = false

func _ready():
	# Load enemy scenes
	enemy_scenes.append(preload("res://scenes/Jellyfish.tscn"))  # Easy enemy
	enemy_scenes.append(preload("res://scenes/Octopus.tscn"))    # Medium enemy  
	enemy_scenes.append(preload("res://scenes/Shark.tscn"))      # Hard enemy
	
	player = get_tree().get_first_node_in_group("player")
	if player:
		player.player_died.connect(_on_player_died)
	
	# Setup timer
	spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_interval
	spawn_timer.timeout.connect(_spawn_enemy)
	add_child(spawn_timer)
	spawn_timer.start()

func _process(delta):
	if not game_over:
		game_timer += delta
	
func _on_player_died():
	game_over = true
	print("GAME OVER")
	# Stop enemy spawning
	spawn_timer.stop()
	# TODO show game over screen

func _spawn_enemy():
	if not player:
		return
	add_to_group("spawners")
	# Progressive enemy selection based on time
	var enemy_scene
	if game_timer < 30.0:
		# First 30 seconds: Only jellyfish (easy)
		enemy_scene = enemy_scenes[0]
	elif game_timer < 60.0:
		# 30-60 seconds: Jellyfish and octopus
		enemy_scene = enemy_scenes[randi() % 2]
	else:
		# After 60 seconds: All enemy types
		enemy_scene = enemy_scenes[randi() % enemy_scenes.size()]
	
	var enemy = enemy_scene.instantiate()
	
	# Spawn at random position around player
	var angle = randf() * TAU
	var spawn_pos = player.global_position + Vector2.from_angle(angle) * spawn_distance
	enemy.global_position = spawn_pos
	
	get_parent().add_child(enemy)
