extends Control

@onready var depth_label = $StatsContainer/DepthLabel
@onready var kills_label = $StatsContainer/KillsLabel
@onready var level_label = $StatsContainer/LevelLabel
@onready var restart_button = $ButtonContainer/RestartButton
@onready var quit_button = $ButtonContainer/QuitButton

func _ready():
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	visible = false
	restart_button.pressed.connect(_on_restart_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func show_game_over():
	get_tree().paused = true
	visible = true
	
	# Display final stats
	depth_label.text = "Depth Reached: " + str(ScoreCounter.get_score()) + "m"
	kills_label.text = "Enemies Defeated: " + str(ScoreCounter.get_kills())
	level_label.text = "Level Reached: " + str(XpManager.current_level)

func _on_restart_pressed():
	#TODO - Game freezes when restart is pressed. Enemies all dissapear, no spawning of new enemies, xp_orbs remain, player cannot move. 
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.queue_free()
	for spawner in get_tree().get_nodes_in_group("spawners"):
		spawner.remove_from_group("spawners")
	ScoreCounter.reset()
	XpManager.reset()
	UpgradeManager.reset_stats()
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_pressed():
	get_tree().quit()
