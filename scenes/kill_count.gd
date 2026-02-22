extends Label

func _ready():
	if ScoreCounter:
		ScoreCounter.enemy_killed.connect(_on_enemy_killed)
	update_display()

func _on_enemy_killed(kill_count: int):
	update_display(kill_count)

func update_display(kills: int = 0):
	text = "Kills: " + str(kills)
