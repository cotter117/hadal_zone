extends Area2D

var xp_value: int = 1
var move_speed: float = 100.0
var player: Node2D

func _ready():
	body_entered.connect(_on_body_entered)
	player = get_node("/root/Main/Player")

func _process(delta):
	if player:
		var distance = global_position.distance_to(player.global_position)
		if distance < 50:  # Magnet range
			var direction = (player.global_position - global_position).normalized()
			global_position += direction * move_speed * delta

func _on_body_entered(body):
	if body.name == "Player":
		XpManager.add_xp(xp_value)
		queue_free()
