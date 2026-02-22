extends Node

signal score_changed(new_score)
signal enemy_killed(kill_count)

var current_score: int = 0
var depth_meters: float = 0.0
var depth_rate: float = 10.0  # meters per second
var kill_count: int = 0

func _ready():
	set_process(true)

func _process(delta):
	depth_meters += depth_rate * delta
	update_score()

func update_score():
	var new_score = int(depth_meters)
	if new_score != current_score:
		current_score = new_score
		score_changed.emit(current_score)

func add_bonus_score(points: int):
	current_score += points
	score_changed.emit(current_score)

func add_kill():
	kill_count += 1
	enemy_killed.emit(kill_count)

func get_score() -> int:
	return current_score

func get_kills() -> int:
	return kill_count

func reset():
	current_score = 0
	depth_meters = 0.0
	kill_count = 0
	score_changed.emit(current_score)
	enemy_killed.emit(kill_count)
