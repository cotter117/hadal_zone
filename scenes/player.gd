extends CharacterBody2D

@export var speed: float = 300.0
@export var fire_rate: float = 0.5 # Shots per second
@export var bullet_speed: float = 500.0

var bullet_scene = preload("res://scenes/Bullet.tscn")
var fire_timer: Timer

func _ready():
	print("Player submarine initialized")
	
	# Setupe auto-fire timer
	fire_timer = Timer.new()
	fire_timer.wait_time = fire_rate
	fire_timer.timeout.connect(_fire_bullet)
	add_child(fire_timer)
	fire_timer.start()

func _physics_process(delta):
	handle_input()
	move_and_slide()

func handle_input():
	var input_vector = Vector2.ZERO
	
	if Input.is_action_pressed("move_up"):
		input_vector.y -= 1
	if Input.is_action_pressed("move_down"):
		input_vector.y += 1
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1
	
	velocity = input_vector.normalized() * speed
	
func _fire_bullet():
	# FInd nearest enemy
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.is_empty():
		return
		
	var nearest_enemy = null
	var nearest_distance = INF
	
	for enemy in enemies:
		var distance = global_position.distance_to(enemy.global_position)
		if distance < nearest_distance:
			nearest_distance = distance
			nearest_enemy = enemy
	
	if nearest_enemy:
		var bullet = bullet_scene.instantiate()
		bullet.global_position = global_position
		
		# Aim at nearest enemy
		var direction = (nearest_enemy.global_position - global_position)
		bullet.velocity = direction * bullet_speed
	
		get_parent().add_child(bullet)
