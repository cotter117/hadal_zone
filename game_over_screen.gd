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
	# Disable all enemy processing first
	get_tree().call_group("enemies", "set_process", false)
	get_tree().call_group("enemies", "set_physics_process", false)
	
	# Stop enemies spawning
	get_tree().call_group("spawners", "set_process", false)
	
	# Reset all systems
	ScoreCounter.reset()
	XpManager.reset()
	UpgradeManager.reset_stats()
	
	# Restart immediately
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_pressed():
	get_tree().quit()
