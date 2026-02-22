extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		var player = get_parent()
		if player.has_method("take_damage"):
			player.take_damage(1)
