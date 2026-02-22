extends Node

signal xp_changed(current_xp, xp_needed)
signal level_up(new_level)

var current_xp: int = 0
var current_level: int = 1
var xp_needed: int = 10

func add_xp(amount: int):
	current_xp += amount
	xp_changed.emit(current_xp, xp_needed)
	
	if current_xp >= xp_needed:
		level_up_player()

func level_up_player():
	current_level += 1
	current_xp -= xp_needed
	xp_needed = int(xp_needed * 1.2)  # Increase XP requirement
	level_up.emit(current_level)

func reset():
	current_xp = 0
	current_level = 1
	xp_needed = 10
