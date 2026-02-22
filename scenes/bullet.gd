extends Area2D

var velocity: Vector2 = Vector2.ZERO

func _ready():
	body_entered.connect(_on_body_entered)
	# Auto-destroy after 3 seconds
	get_tree().create_timer(3.0).timeout.connect(queue_free)

func _physics_process(delta):
	position += velocity * delta

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		if body.has_method("take_damage"):
			body.take_damage(1)
			#ScoreCounter.add_kill() # Updates kill display
			#var xp_orb = preload("res://scenes/xp_orb.tscn").instantiate()
			#xp_orb.global_position = global_position
			#get_parent().add_child(xp_orb)
		else:
			body.queue_free # Fallback
		queue_free()
		ScoreCounter.add_kill() # Updates kill display
		var xp_orb = preload("res://scenes/xp_orb.tscn").instantiate()
		xp_orb.global_position = global_position
		get_parent().add_child(xp_orb)
