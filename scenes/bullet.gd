extends Area2D

var velocity: Vector2 = Vector2.ZERO
var damage: float = 1.0

func _ready():
	body_entered.connect(_on_body_entered)
	# Auto-destroy after 3 seconds
	get_tree().create_timer(3.0).timeout.connect(queue_free)

func _physics_process(delta):
	position += velocity * delta

func _on_body_entered(body):
	#TODO - all enemies die on singel hit regardless of health. Even when healt set in inspector
	if body.is_in_group("enemies"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
		else:
			body.queue_free()
		queue_free()
		
