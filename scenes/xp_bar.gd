extends ProgressBar

func _ready():
	if XpManager:
		XpManager.xp_changed.connect(_on_xp_changed)

func _on_xp_changed(current_xp: int, xp_needed: int):
	max_value = xp_needed
	value = current_xp
