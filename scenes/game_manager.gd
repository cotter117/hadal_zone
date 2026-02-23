extends Node

@onready var game_over_screen = get_node("../UI/GameOverScreen")

func _ready():
	# Connect to player death signal
	var player = get_node("../Player")
	if player and player.has_signal("player_died"):
		player.player_died.connect(_on_player_died)

func _on_player_died():
	if game_over_screen:
		game_over_screen.show_game_over()
