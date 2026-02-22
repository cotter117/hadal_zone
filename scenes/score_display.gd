extends Label

@onready var score_counter = get_node("/root/ScoreCounter")

func _ready():
	if score_counter:
		score_counter.score_changed.connect(_on_score_changed)

func _on_score_changed(new_score: int):
	text = str(new_score) + "m"
