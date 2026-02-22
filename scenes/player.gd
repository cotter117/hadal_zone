extends CharacterBody2D

@export var base_speed: float = 300.0
@export var current_speed: float
@export var base_fire_rate: float = 1.0
@export var current_fire_rate: float
@export var base_damage: float = 10.0
@export var current_damage: float
@export var base_weapon_speed: float = 500.0
@export var current_weapon_speed: float
@export var max_health: int = 3
@export var invincibility_time: float = 1.0

var bullet_scene = preload("res://scenes/Bullet.tscn")
var fire_timer: Timer
var current_health: int
var is_invincible: bool = false
var invincibility_timer: Timer
var flash_timer: float = 0.0

signal player_died
signal health_changed(new_health)

func _ready():
	print("Player submarine initialized")
	current_health = max_health
	update_speed()
	update_weapon_stats()
	
	# Setup auto-fire timer
	fire_timer = Timer.new()
	fire_timer.wait_time = current_fire_rate
	fire_timer.timeout.connect(_fire_bullet)
	add_child(fire_timer)
	fire_timer.start()
	
	# Setup invincibility timer
	invincibility_timer = Timer.new()
	invincibility_timer.wait_time = invincibility_time
	invincibility_timer.timeout.connect(_end_invincibility)
	add_child(invincibility_timer)

func _physics_process(delta):
	handle_input()
	move_and_slide()
	
	# Visual feedback when invincible
	if is_invincible:
		flash_timer += delta
		modulate.a = 0.5 + 0.5 * sin(flash_timer * 10)
	else:
		modulate.a = 1.0

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
	
	velocity = input_vector.normalized() * current_speed

func _fire_bullet():
	# Find nearest enemy
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
		var direction = (nearest_enemy.global_position - global_position).normalized()
		bullet.velocity = direction * current_weapon_speed
		
		get_parent().add_child(bullet)

func take_damage(amount: int):
	if is_invincible:
		return
	
	current_health -= amount
	health_changed.emit(current_health)
	print("Player health: ", current_health)
	
	if current_health <= 0:
		die()
	else:
		# Start invincibility period
		is_invincible = true
		flash_timer = 0.0
		invincibility_timer.start()

func _end_invincibility():
	is_invincible = false

func die():
	print("Player died!")
	player_died.emit()
	# Stop all timers
	fire_timer.stop()
	invincibility_timer.stop()
	# Disable movement
	set_physics_process(false)
	
func update_speed():
	current_speed = base_speed * UpgradeManager.get_stat("speed_multiplier")

func update_weapon_stats():
	current_damage = base_damage * UpgradeManager.get_stat("damage_multiplier")
	current_fire_rate = base_fire_rate * UpgradeManager.get_stat("fire_rate_multiplier")
	current_weapon_speed = base_weapon_speed * UpgradeManager.get_stat("weapon_speed_multiplier")
