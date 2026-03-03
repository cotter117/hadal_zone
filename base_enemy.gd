extends CharacterBody2D
@export var speed: float = 80.0
@export var health: float = 10.0

var player: Node2D

func _ready():
	add_to_group("enemies")  # Also fixes NEW-E01
	player = get_tree().get_first_node_in_group("player")


func _physics_process(delta):
	if is_instance_valid(player):  # Also fixes NEW-E02
		var distance = global_position.distance_to(player.global_position)
		if distance > 1200:
			queue_free()
			return
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()

func take_damage(amount: float):
	health -= amount
	if health <= 0.0:
		ScoreCounter.add_kill()
		var xp_orb = preload("res://scenes/xp_orb.tscn").instantiate()
		xp_orb.global_position = global_position
		get_parent().add_child(xp_orb)
		queue_free()
