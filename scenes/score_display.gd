extends Label

func _ready():
	process_mode = Node.PROCESS_MODE_PAUSABLE
	if ScoreCounter:
		ScoreCounter.score_changed.connect(_on_score_changed)

func _on_score_changed(new_score: int):
	text = str(new_score) + "m"
