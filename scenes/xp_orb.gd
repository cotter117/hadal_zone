extends Area2D

var xp_value: int = 1
var move_speed: float = 500.0
var player: Node2D

func _ready():
	#TODO a single orb remains on screen after restart, always in same position. 
	body_entered.connect(_on_body_entered)
	player = get_tree().get_first_node_in_group("player")

func _process(delta):
	if is_instance_valid(player):
		var distance = global_position.distance_to(player.global_position)
		var magnet_range = 50 + UpgradeManager.get_stat("magnet_range_bonus")
		if distance < magnet_range:  # Magnet range
			var direction = (player.global_position - global_position).normalized()
			global_position += direction * move_speed * delta

func _on_body_entered(body):
	if body.is_in_group("player"):
		XpManager.add_xp(xp_value)
		queue_free()
